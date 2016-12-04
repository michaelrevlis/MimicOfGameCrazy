//
//  SettingTableViewController.swift
//  MimicOfGameCrazyApp
//
//  Created by MichaelRevlis on 2016/11/30.
//  Copyright © 2016年 MichaelRevlis. All rights reserved.
//

import UIKit

class SettingTableViewController: UITableViewController {
    
    private let settingItems = ["ACG大百科", "特別企劃", "花絮", "攻略報報"]

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "返回", style: .Plain, target: nil, action: nil)
        
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return settingItems.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("settingTableCell", forIndexPath: indexPath)  as! SettingTableViewCell

        cell.settingButton.setTitle(settingItems[indexPath.row], forState: .Normal)

        return cell
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
