//
//  GameCrazyTableViewController.swift
//  MimicOfGameCrazyApp
//
//  Created by MichaelRevlis on 2016/11/30.
//  Copyright © 2016年 MichaelRevlis. All rights reserved.
//

import UIKit

class GameCrazyTableViewController: UITableViewController {

    private var playlistResult = [Playlist]()
    private var sections: [Section] = [.AD, .Playlist]
    private var ad = [AD]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        YoutuberManager.shared.gamecrazyDelegate = self
        
        YoutuberManager.shared.getPlaylistData(.GameCrazy)

        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 96

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
        case .AD: return AD1TableViewCell.Static.Height
        case .Playlist: return UITableViewAutomaticDimension
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        switch sections[indexPath.section] {
        case .AD:
            let adCell = tableView.dequeueReusableCellWithIdentifier("Ad1TableViewCell", forIndexPath: indexPath) as! AD1TableViewCell
            
            adCell.AdImageView.image = UIImage(named: self.ad[0].imageName)
            
            return adCell
            
        case .Playlist:
            let cell = tableView.dequeueReusableCellWithIdentifier("gamecrazyTableCell", forIndexPath: indexPath) as! GameCrazyTableViewCell
            
            let index = self.playlistResult[indexPath.row]
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
            case "showCrazy":
                let webVC = segue.destinationViewController as! CrazyViewController
                
                if let indexPath = self.tableView.indexPathForCell(sender as! UITableViewCell) {
                    let videoId = playlistResult[indexPath.row].videoId
                    webVC.videoId = videoId
                }
                
            case "showAd1":
                let adVC = segue.destinationViewController as! AdViewController
                
                adVC.urlString = self.ad[0].url
                
            default: break
            }
        }
    }

}



extension GameCrazyTableViewController: YoutuberManagerDelegate {
    func manager(manager: YoutuberManager, playlistResult: [Playlist]) {
        self.playlistResult = playlistResult
        self.tableView.reloadData()
    }
}




