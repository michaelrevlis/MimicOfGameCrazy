//
//  ADTableViewCell.swift
//  MimicOfGameCrazyApp
//
//  Created by MichaelRevlis on 2016/11/30.
//  Copyright © 2016年 MichaelRevlis. All rights reserved.
//

import UIKit

class AD2TableViewCell: UITableViewCell {
    
    @IBOutlet weak var ContentView: UIView!
    @IBOutlet weak var AdImageView: UIImageView!
    
    
    struct Static {
        static let Identifier = "AD2TableViewCell"
        static let Height: CGFloat = 180
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        AdImageView.contentMode = .ScaleAspectFill
        
        self.ContentView.addSubview(AdImageView)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}