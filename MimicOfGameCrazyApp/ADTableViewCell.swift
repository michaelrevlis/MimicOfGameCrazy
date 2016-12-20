//
//  ADTableViewCell.swift
//  MimicOfGameCrazyApp
//
//  Created by MichaelRevlis on 2016/12/4.
//  Copyright © 2016年 MichaelRevlis. All rights reserved.
//

import UIKit

class ADTableViewCell: UITableViewCell {

    @IBOutlet weak var ContentView: UIView!
    @IBOutlet weak var AdImageView: UIImageView!
    
    struct Static {
        static let Identifier = "ADTableViewCell"
        static let Height: CGFloat = 180
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        AdImageView.contentMode = .scaleToFill
    }
    
}
