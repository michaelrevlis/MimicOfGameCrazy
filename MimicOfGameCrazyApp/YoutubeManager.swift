//
//  YoutubeManager.swift
//  MimicOfGameCrazyApp
//
//  Created by MichaelRevlis on 2016/11/30.
//  Copyright © 2016年 MichaelRevlis. All rights reserved.
//

import UIKit
import Foundation
import youtube_ios_player_helper

class YoutuberManager {
    
    static let shared = YoutuberManager()
    
    fileprivate let apiKey = "AIzaSyBXKpFxcL9A6yyJ_FaZb0jyHsASFjUhH1Q"
    fileprivate let channelId = "UC4c-wTOqEID-_vH4MhNs06w"
    fileprivate let 陪你去看電玩瘋 = "PLDB-qS0bMlKEKf9HmaDvEHedn5n059RfB"
    fileprivate let 直播影片 = "PLDB-qS0bMlKGUbSK7LWnOltKSyNVV6XWZ"
    fileprivate let 遊戲製作團隊來訪 = "PLDB-qS0bMlKE8y24f8HOx1VJSmgdyk7g3"
    fileprivate let VR遊戲直播 = "PLDB-qS0bMlKFpi_WYPfrEQBsJkgOZSdnZ"
    
    weak var gamecrazyDelegate: YoutuberManagerDelegate?
    weak var liveDelegate: YoutuberManagerDelegate?
    weak var gameproducerDelegate: YoutuberManagerDelegate?
    weak var vrgameDelegate: YoutuberManagerDelegate?
    weak var gamecrazySearchDelegate: YoutuberManagerSearchDelegate?
    weak var liveSearchDelegate: YoutuberManagerSearchDelegate?
    weak var gameproducerSearchDelegate: YoutuberManagerSearchDelegate?
    weak var vrgameSearchDelegate: YoutuberManagerSearchDelegate?
    
    //////////////////////
    //// Playlist ////
    /////////////////////
    
    typealias PerformGetRequest = (_ data: Data?, _ HTTPStatusCode: Int, _ error: NSError?) -> Void
    
    fileprivate func performGetRequest(_ targetURL: URL!, completion: @escaping PerformGetRequest) {
        
        let request = NSMutableURLRequest(url: targetURL)
        request.httpMethod = "GET"
        
        let sessionConfigureation = URLSessionConfiguration.default
        
        let session = URLSession(configuration: sessionConfigureation)
        
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            let httpResponse = response as? HTTPURLResponse
            DispatchQueue.main.async(execute: { () -> Void in
                completion(data, (httpResponse?.statusCode)!, error as NSError?)
            })
        }
        task.resume()
    }
    
    
    
    func getPlaylistData(_ playlistType: PlaylistType, nextPageToken: String) {
        
        var urlString = String()
        
        switch playlistType {
        case .gameCrazy:
            urlString = "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=\(陪你去看電玩瘋)&key=\(apiKey)&maxResults=\(10)&pageToken=\(nextPageToken)"
            
        case .live:
            urlString = "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=\(直播影片)&key=\(apiKey)&maxResults=\(10)&pageToken=\(nextPageToken)"
            
        case .gameProducer:
            urlString = "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=\(遊戲製作團隊來訪)&key=\(apiKey)&maxResults=\(10)&pageToken=\(nextPageToken)"
            
        case .vrGame:
            urlString = "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=\(VR遊戲直播)&key=\(apiKey)&maxResults=\(10)&pageToken=\(nextPageToken)"
        }

        
        guard let gamecrazyUrl = URL(string: urlString)
            else {
                print("Error: NSURL gamecrazyUrl")
                return
        }
        
        performGetRequest(gamecrazyUrl, completion: { (data, HTTPStatusCode, error) -> Void in
            
            var playlistResult = [Playlist]()
            
            if HTTPStatusCode == 200 && error == nil {
                do {
                    guard let  resultsDict = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary,
                                    let items = resultsDict["items"] as? NSArray
                        else { fatalError() }
                    
                    let nextPageToken = resultsDict["nextPageToken"] as? String ?? "End"
                    print("NEXT")
                    print(nextPageToken)
                    
                    for i in 0...items.count - 1 {
                        guard let  itemDict = items[i] as? NSDictionary,
                                        let snippet = itemDict["snippet"] as? NSDictionary,
                                        let title = snippet["title"] as? String,
                                        let thumbnail = snippet["thumbnails"] as? NSDictionary,
                                        let defaults = thumbnail["default"] as? NSDictionary,
                                        let thumbnailUrl = defaults["url"] as? String,
                                        let resourceId = snippet["resourceId"] as? NSDictionary,
                                        let videoId = resourceId["videoId"] as? String
                            else { fatalError() }
                        
                        playlistResult.append(Playlist(title: title, thumbnailUrl: thumbnailUrl, videoId: videoId))
                    }
                    
                    switch playlistType {
                    case .gameCrazy:
                        DispatchQueue.main.async(execute: {
                            self.gamecrazyDelegate?.manager(self, playlistResult: playlistResult, nextPageToken: nextPageToken)
                        })
                        
                    case .live:
                        DispatchQueue.main.async(execute: {
                            self.liveDelegate?.manager(self, playlistResult: playlistResult, nextPageToken: nextPageToken)
                        })
                        
                    case .gameProducer:
                        DispatchQueue.main.async(execute: {
                            self.gameproducerDelegate?.manager(self, playlistResult: playlistResult, nextPageToken: nextPageToken)
                        })
                        
                    case .vrGame:
                        DispatchQueue.main.async(execute: {
                            self.vrgameDelegate?.manager(self, playlistResult: playlistResult, nextPageToken: nextPageToken)
                        })
                    }
  
                } catch {
                    print(error)
                }
                
            } else {
                print("HTTP status code: \(HTTPStatusCode)")
                print("Error while loading channel details: \(error)")
            }
        })
    }
    
    ////////////////////////////////
    //// Search Video ////
    ///////////////////////////////

    func searchVideo(_ keyword: String, vc: PlaylistType) {
        let urlString = "https://www.googleapis.com/youtube/v3/search?part=snippet&q=\(keyword)&channelId=\(channelId)&maxResults=\(20)&type=video&key=\(apiKey)"
        
        guard let searchUrl = URL(string: urlString)
            else {
                print("Error: NSURL gamecrazyUrl")
                return
        }
        
        performGetRequest(searchUrl, completion: { (data, HTTPStatusCode, error) -> Void in
            
            var searchResult = [Playlist]()
            
            if HTTPStatusCode == 200 && error == nil {
                do {
                    guard let  resultsDict = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary,
                        let items = resultsDict["items"] as? NSArray
                        else { fatalError() }
                    
                    guard items.count != 0 else { return }
                    
                    for i in 0...items.count - 1 {
                        guard let  itemDict = items[i] as? NSDictionary,
                                        let snippet = itemDict["snippet"] as? NSDictionary,
                                        let title = snippet["title"] as? String,
                                        let thumbnail = snippet["thumbnails"] as? NSDictionary,
                                        let defaults = thumbnail["default"] as? NSDictionary,
                                        let thumbnailUrl = defaults["url"] as? String,
                                        let resourceId = itemDict["id"] as? NSDictionary,
                                        let videoId = resourceId["videoId"] as? String
                            else { fatalError() }
                        
                        searchResult.append(Playlist(title: title, thumbnailUrl: thumbnailUrl, videoId: videoId))
                    }
                    
                    switch vc {
                    case .gameCrazy:
                        DispatchQueue.main.async(execute: {
                            self.gamecrazySearchDelegate?.manager(self, searchResult: searchResult)
                        })
                        
                    case .live:
                        DispatchQueue.main.async(execute: {
                            self.liveSearchDelegate?.manager(self, searchResult: searchResult)
                        })
                        
                    case .gameProducer:
                        DispatchQueue.main.async(execute: {
                            self.gameproducerSearchDelegate?.manager(self, searchResult: searchResult)
                        })
                        
                    case .vrGame:
                        DispatchQueue.main.async(execute: {
                            self.vrgameSearchDelegate?.manager(self, searchResult: searchResult)
                        })
                    }
                    
                } catch {
                    print(error)
                }
                
            } else {
                print("HTTP status code: \(HTTPStatusCode)")
                print("Error while loading channel details: \(error)")
            }
        })

    }
    
    
}



protocol YoutuberManagerDelegate: class {
    func manager(_ manager: YoutuberManager, playlistResult: [Playlist], nextPageToken: String)
}

protocol YoutuberManagerSearchDelegate: class {
    func manager(_ manager: YoutuberManager, searchResult: [Playlist])
}




