//
//  PlaylistTableViewCell.swift
//  MimicOfGameCrazyApp
//
//  Created by MichaelRevlis on 2016/12/4.
//  Copyright © 2016年 MichaelRevlis. All rights reserved.
//

import UIKit

class PlaylistTableViewCell: UITableViewCell {

    @IBOutlet weak var ContentView: UIView!
    @IBOutlet weak var PlayerView: UIImageView!
    @IBOutlet weak var TitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        //// PlayerView ////
        let PlayerViewWidth: CGFloat = UIScreen.main.bounds.size.width / 3
        let PlayerViewWidthConstraint = NSLayoutConstraint(item: PlayerView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: PlayerViewWidth)
        let PlayerViewHeightConstraint = NSLayoutConstraint(item: PlayerView, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: PlayerViewWidth * 0.6)
        let PlayerViewLeadingConstraint = NSLayoutConstraint(item: PlayerView, attribute: .leading, relatedBy: .equal, toItem: ContentView, attribute: .leading, multiplier: 1, constant: 0)
        let PlayerViewTopConstraint = NSLayoutConstraint(item: PlayerView, attribute: .top, relatedBy: .equal, toItem: ContentView, attribute: .top, multiplier: 1, constant: 0)
        
        PlayerView.translatesAutoresizingMaskIntoConstraints = false
        ContentView.addSubview(PlayerView)
        ContentView.addConstraints([PlayerViewWidthConstraint, PlayerViewHeightConstraint, PlayerViewLeadingConstraint, PlayerViewTopConstraint])
        
        
        //// TitleLabel ////
        let TitleLabelTopConstraint = NSLayoutConstraint(item: TitleLabel, attribute: .top, relatedBy: .equal, toItem: ContentView, attribute: .top, multiplier: 1, constant: 16)
        let TitleLabelBottomConstraint = NSLayoutConstraint(item: TitleLabel, attribute: .bottom, relatedBy: .equal, toItem: ContentView, attribute: .bottom, multiplier: 1, constant: 16)
        let TitleLabelLeadingConstraint = NSLayoutConstraint(item: TitleLabel, attribute: .leading, relatedBy: .equal, toItem: PlayerView, attribute: .trailing, multiplier: 1, constant: 8)
        let TitleLabelTrailingConstraint = NSLayoutConstraint(item: TitleLabel, attribute: .trailing, relatedBy: .equal, toItem: ContentView, attribute: .trailing, multiplier: 1, constant: 8)
        
        let TitleLabelHeight = NSLayoutConstraint(item: TitleLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 96)
        
        TitleLabel.translatesAutoresizingMaskIntoConstraints = false
        ContentView.addSubview(TitleLabel)
        ContentView.addConstraints([TitleLabelTopConstraint, TitleLabelBottomConstraint, TitleLabelLeadingConstraint, TitleLabelTrailingConstraint, TitleLabelHeight])
}
    
}
