//
//  TableViewCell.swift
//  MimicOfGameCrazyApp
//
//  Created by MichaelRevlis on 2016/11/30.
//  Copyright © 2016年 MichaelRevlis. All rights reserved.
//

import UIKit

class GameCrazyTableViewCell: UITableViewCell {

    @IBOutlet weak var ContentView: UIView!
    @IBOutlet weak var PlayerView: UIImageView!
    @IBOutlet weak var TitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        

        //// PlayerView ////
        let PlayerViewWidth: CGFloat = UIScreen.mainScreen().bounds.size.width / 3
        let PlayerViewWidthConstraint = NSLayoutConstraint(item: PlayerView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: PlayerViewWidth)
        let PlayerViewHeightConstraint = NSLayoutConstraint(item: PlayerView, attribute: .Height, relatedBy: .GreaterThanOrEqual, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: PlayerViewWidth * 0.6)
        let PlayerViewLeadingConstraint = NSLayoutConstraint(item: PlayerView, attribute: .Leading, relatedBy: .Equal, toItem: ContentView, attribute: .Leading, multiplier: 1, constant: 0)
        let PlayerViewTopConstraint = NSLayoutConstraint(item: PlayerView, attribute: .Top, relatedBy: .Equal, toItem: ContentView, attribute: .Top, multiplier: 1, constant: 0)
        
        PlayerView.translatesAutoresizingMaskIntoConstraints = false
        ContentView.addSubview(PlayerView)
        ContentView.addConstraints([PlayerViewWidthConstraint, PlayerViewHeightConstraint, PlayerViewLeadingConstraint, PlayerViewTopConstraint])
        
        
        //// TitleLabel ////
        let TitleLabelTopConstraint = NSLayoutConstraint(item: TitleLabel, attribute: .Top, relatedBy: .Equal, toItem: ContentView, attribute: .Top, multiplier: 1, constant: 16)
        let TitleLabelBottomConstraint = NSLayoutConstraint(item: TitleLabel, attribute: .Bottom, relatedBy: .Equal, toItem: ContentView, attribute: .Bottom, multiplier: 1, constant: 16)
        let TitleLabelLeadingConstraint = NSLayoutConstraint(item: TitleLabel, attribute: .Leading, relatedBy: .Equal, toItem: PlayerView, attribute: .Trailing, multiplier: 1, constant: 8)
        let TitleLabelTrailingConstraint = NSLayoutConstraint(item: TitleLabel, attribute: .Trailing, relatedBy: .Equal, toItem: ContentView, attribute: .Trailing, multiplier: 1, constant: 8)
        
        let TitleLabelHeight = NSLayoutConstraint(item: TitleLabel, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 96)
        
        TitleLabel.translatesAutoresizingMaskIntoConstraints = false
        ContentView.addSubview(TitleLabel)
        ContentView.addConstraints([TitleLabelTopConstraint, TitleLabelBottomConstraint, TitleLabelLeadingConstraint, TitleLabelTrailingConstraint, TitleLabelHeight])

    }
}
