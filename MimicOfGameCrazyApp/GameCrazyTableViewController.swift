//
//  GameCrazyTableViewController.swift
//  MimicOfGameCrazyApp
//
//  Created by MichaelRevlis on 2016/11/30.
//  Copyright © 2016年 MichaelRevlis. All rights reserved.
//

import UIKit

class GameCrazyTableViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!

    fileprivate var playlistResult = [Playlist]()
    fileprivate var sections: [Section] = [.ad, .playlist]
    fileprivate var ad = [AD]()
    fileprivate var searchResult = [Playlist]()
    fileprivate var inSearchMode = false
    fileprivate var pageToken = ""
    fileprivate var isPageRefreshing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        YoutuberManager.shared.gamecrazyDelegate = self
        YoutuberManager.shared.gamecrazySearchDelegate = self

        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 96
        
        searchBar.delegate = self

        self.tableView.setContentOffset(CGPoint(x: 0.0, y: 44.0), animated: true)
        
        let nib = UINib(nibName: "PlaylistTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "gamecrazyTableCell")
        
        let nib2 = UINib(nibName: "ADTableViewCell", bundle: nil)
        self.tableView.register(nib2, forCellReuseIdentifier: "Ad1TableViewCell")
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        AdGenerator.shared.random {(result) in
            self.ad.append(result)
        }

        self.tableView.reloadData()
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        self.ad.removeAll()
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch sections[section] {
        case .ad:
            return 1
        case .playlist:
            return playlistResult.count
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch sections[indexPath.section] {
        case .ad: return ADTableViewCell.Static.Height
        case .playlist: return UITableViewAutomaticDimension
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch sections[indexPath.section] {
        case .ad:
            let adCell = tableView.dequeueReusableCell(withIdentifier: "Ad1TableViewCell", for: indexPath) as! ADTableViewCell
            
            adCell.AdImageView.image = UIImage(named: self.ad[0].imageName)
            
            return adCell
            
        case .playlist:
            let cell = tableView.dequeueReusableCell(withIdentifier: "gamecrazyTableCell", for: indexPath) as! PlaylistTableViewCell
            
            let index: Playlist
            if self.searchResult.count == 0 {
                index = self.playlistResult[indexPath.row]
            } else {
                index = self.searchResult[indexPath.row]
            }
            cell.TitleLabel.text = index.title
            guard let imageUrl = URL(string: index.thumbnailUrl)
                else { fatalError() }
            guard let imageData = try? Data(contentsOf: imageUrl)
                else { fatalError() }
            cell.PlayerView.image = UIImage(data: imageData)
            
            return cell
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch sections[indexPath.section] {
        case .ad:
            self.performSegue(withIdentifier: "showAd1", sender: indexPath.row)
        case .playlist:
            self.performSegue(withIdentifier: "showCrazy", sender: indexPath.row)
        }
    }
    
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.tableView.contentOffset.y >= (self.tableView.contentSize.height - self.tableView.bounds.size.height) {
            if self.isPageRefreshing == false {
                if self.pageToken != "End" {
                isPageRefreshing = true
                YoutuberManager.shared.getPlaylistData(.gameCrazy, nextPageToken: pageToken)
                }
            }
        }
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "showCrazy":
                let webVC = segue.destination as! CrazyViewController
                
                if let indexPath = self.tableView.indexPathForSelectedRow {
                    let videoId: String
                    if searchResult.count == 0 {
                        videoId = playlistResult[indexPath.row].videoId
                    } else {
                        videoId = searchResult[indexPath.row].videoId
                    }
                    webVC.videoId = videoId
                }
                
            case "showAd1":
                let adVC = segue.destination as! AdViewController
                
                adVC.urlString = self.ad[0].url
                
            default: break
            }
        }
    }
    
    
    
    @IBAction func openGNN(_ sender: AnyObject) {
        UIApplication.shared.openURL(GNN.url as URL)
    }

}



extension GameCrazyTableViewController: YoutuberManagerDelegate {
    func manager(_ manager: YoutuberManager, playlistResult: [Playlist], nextPageToken: String) {
        for result in playlistResult {
            self.playlistResult.append(result)
        }
        self.pageToken = nextPageToken
        self.isPageRefreshing = false
        self.tableView.reloadData()
    }
}


extension GameCrazyTableViewController: YoutuberManagerSearchDelegate {
    func manager(_ manager: YoutuberManager, searchResult: [Playlist]) {
        self.searchResult = searchResult
        self.tableView.reloadData()
    }
}


extension GameCrazyTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            view.endEditing(true)
            self.searchResult.removeAll()
            tableView.reloadData()
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            view.endEditing(true)
            self.searchResult.removeAll()
            tableView.reloadData()
        } else {
            inSearchMode = true
            let searchKeyWord = searchBar.text!.lowercased()
            YoutuberManager.shared.searchVideo(searchKeyWord, vc: .gameCrazy)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.showsCancelButton = false
        inSearchMode = false
        view.endEditing(true)
    }
}



