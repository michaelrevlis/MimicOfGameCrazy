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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        YoutuberManager.shared.gamecrazyDelegate = self
        
        YoutuberManager.shared.getPlaylistData(.GameCrazy)

        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 96

    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlistResult.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

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


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}



extension GameCrazyTableViewController: YoutuberManagerGameCrazyDelegate {
    func gamecrazyManager(manager: YoutuberManager, playlistResult: [Playlist]) {
        self.playlistResult = playlistResult
        self.tableView.reloadData()
    }
}




