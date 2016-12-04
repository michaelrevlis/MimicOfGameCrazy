//
//  Objects.swift
//  MimicOfGameCrazyApp
//
//  Created by MichaelRevlis on 2016/11/30.
//  Copyright © 2016年 MichaelRevlis. All rights reserved.
//

import Foundation

class Playlist {
    let title: String
    let thumbnailUrl: String
    let videoId: String
    
    init(title: String, thumbnailUrl: String, videoId: String) {
        self.title = title
        self.thumbnailUrl = thumbnailUrl
        self.videoId = videoId
    }
}



class AD {
    let imageName: String
    let url: String
    
    init(imageName: String, url: String) {
        self.imageName = imageName
        self.url = url
    }
}


enum PlaylistType: Int {
    case GameCrazy, Live, GameProducer, VRGame
}


enum Section {
    case AD, Playlist
}


struct GNN {
    static let url = NSURL(string: "https://gnn.gamer.com.tw/")!
}

