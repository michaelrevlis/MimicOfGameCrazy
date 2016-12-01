//
//  AdGenerator.swift
//  MimicOfGameCrazyApp
//
//  Created by MichaelRevlis on 2016/11/30.
//  Copyright © 2016年 MichaelRevlis. All rights reserved.
//

import Foundation

class AdGenerator {
    
    static let shared = AdGenerator()
    
    private let ads: [AD] =
        [AD(imageName: "ad1", url: "https://m.gamer.com.tw/gnn/detail.php?sn=140403"),
         AD(imageName: "ad2", url: "https://prj.gamer.com.tw/app2u/animeapp.html"),
         AD(imageName: "ad3", url: "https://prj.gamer.com.tw/acgaward/2017/"),
         AD(imageName: "ad4", url: "https://prj.gamer.com.tw/20y/peripherals.php")]
    
    typealias RandomResult = (result: AD) -> Void
    
    func random(completion: RandomResult) {
        let diceRoll = Int(arc4random_uniform(4))

        completion(result: ads[diceRoll])
    }
}