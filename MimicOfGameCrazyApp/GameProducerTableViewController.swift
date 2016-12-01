//
//  NewGameTableViewController.swift
//  MimicOfGameCrazyApp
//
//  Created by MichaelRevlis on 2016/11/30.
//  Copyright © 2016年 MichaelRevlis. All rights reserved.
//

import UIKit

class GameProducerTableViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var playlistResult = [Playlist]()
    private var sections: [Section] = [.AD, .Playlist]
    private var ad = [AD]()
    private var searchResult = [Playlist]()
    private var inSearchMode = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        YoutuberManager.shared.gameproducerDelegate = self
        YoutuberManager.shared.gameproducerSearchDelegate = self
        YoutuberManager.shared.getPlaylistData(.GameProducer)
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 96
        
        searchBar.delegate = self
        
        self.tableView.setContentOffset(CGPoint(x: 0.0, y: 44.0), animated: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        AdGenerator.shared.random {(result) in
            self.ad.append(result)
        }
        
        self.tableView.reloadData()
    }
    
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
        
        self.ad.removeAll()
    }

    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch sections[section] {
        case .AD:
            return 1
        case .Playlist:
            return playlistResult.count
        }
        
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        switch sections[indexPath.section] {
        case .AD: return AD3TableViewCell.Static.Height
        case .Playlist: return UITableViewAutomaticDimension
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch sections[indexPath.section] {
        case .AD:
            let adCell = tableView.dequeueReusableCellWithIdentifier("Ad3TableViewCell", forIndexPath: indexPath) as! AD3TableViewCell
            
            adCell.AdImageView.image = UIImage(named: self.ad[0].imageName)
            
            return adCell
            
        case .Playlist:
            let cell = tableView.dequeueReusableCellWithIdentifier("gameproducerTableCell", forIndexPath: indexPath) as! GameProducerTableViewCell
            
            let index: Playlist
            if self.searchResult.count == 0 {
                index = self.playlistResult[indexPath.row]
            } else {
                index = self.searchResult[indexPath.row]
            }
            cell.TitleLabel.text = index.title
            guard let imageUrl = NSURL(string: index.thumbnailUrl)
                else { fatalError() }
            guard let imageData = NSData(contentsOfURL: imageUrl)
                else { fatalError() }
            cell.PlayerView.image = UIImage(data: imageData)
            
            return cell
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "showProducer":
                let webVC = segue.destinationViewController as! ProducerViewController
                
                if let indexPath = self.tableView.indexPathForCell(sender as! UITableViewCell) {
                    let videoId: String
                    if searchResult.count == 0 {
                        videoId = playlistResult[indexPath.row].videoId
                    } else {
                        videoId = searchResult[indexPath.row].videoId
                    }
                    webVC.videoId = videoId
                }
                
            case "showAd3":
                let adVC = segue.destinationViewController as! AdViewController
                
                adVC.urlString = self.ad[0].url
                
            default: break
            }
        }
    }
}



extension GameProducerTableViewController: YoutuberManagerDelegate {
    func manager(manager: YoutuberManager, playlistResult: [Playlist]) {
        self.playlistResult = playlistResult
        self.tableView.reloadData()
    }
}


extension GameProducerTableViewController: YoutuberManagerSearchDelegate {
    func manager(manager: YoutuberManager, searchResult: [Playlist]) {
        self.searchResult = searchResult
        self.tableView.reloadData()
    }
}


extension GameProducerTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            view.endEditing(true)
            self.searchResult.removeAll()
            tableView.reloadData()
        }
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            view.endEditing(true)
            self.searchResult.removeAll()
            tableView.reloadData()
        } else {
            inSearchMode = true
            let searchKeyWord = searchBar.text!.lowercaseString
            YoutuberManager.shared.searchVideo(searchKeyWord, vc: .GameProducer)
        }
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.showsCancelButton = false
        inSearchMode = false
        view.endEditing(true)
    }
}



