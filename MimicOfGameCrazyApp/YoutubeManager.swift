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
    
    private let apiKey = "AIzaSyBXKpFxcL9A6yyJ_FaZb0jyHsASFjUhH1Q"
    private let channelId = "UC4c-wTOqEID-_vH4MhNs06w"
    private let 陪你去看電玩瘋 = "PLDB-qS0bMlKEKf9HmaDvEHedn5n059RfB"
    private let 直播影片 = "PLDB-qS0bMlKGUbSK7LWnOltKSyNVV6XWZ"
    private let 遊戲製作團隊來訪 = "PLDB-qS0bMlKE8y24f8HOx1VJSmgdyk7g3"
    private let VR遊戲直播 = "PLDB-qS0bMlKFpi_WYPfrEQBsJkgOZSdnZ"
    
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
    
    typealias PerformGetRequest = (data: NSData?, HTTPStatusCode: Int, error: NSError?) -> Void
    
    private func performGetRequest(targetURL: NSURL!, completion: PerformGetRequest) {
        
        let request = NSMutableURLRequest(URL: targetURL)
        request.HTTPMethod = "GET"
        
        let sessionConfigureation = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        let session = NSURLSession(configuration: sessionConfigureation)
        
        let task = session.dataTaskWithRequest(request, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completion(data: data, HTTPStatusCode: (response as! NSHTTPURLResponse).statusCode, error: error)
            })
        })
        task.resume()
    }
    
    
    
    func getPlaylistData(playlistType: PlaylistType, nextPageToken: String) {
        
        var urlString = String()
        
        switch playlistType {
        case .GameCrazy:
            urlString = "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=\(陪你去看電玩瘋)&key=\(apiKey)&maxResults=\(10)&pageToken=\(nextPageToken)"
            
        case .Live:
            urlString = "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=\(直播影片)&key=\(apiKey)&maxResults=\(10)&pageToken=\(nextPageToken)"
            
        case .GameProducer:
            urlString = "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=\(遊戲製作團隊來訪)&key=\(apiKey)&maxResults=\(10)&pageToken=\(nextPageToken)"
            
        case .VRGame:
            urlString = "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=\(VR遊戲直播)&key=\(apiKey)&maxResults=\(10)&pageToken=\(nextPageToken)"
        }

        
        guard let gamecrazyUrl = NSURL(string: urlString)
            else {
                print("Error: NSURL gamecrazyUrl")
                return
        }
        
        performGetRequest(gamecrazyUrl, completion: { (data, HTTPStatusCode, error) -> Void in
            
            var playlistResult = [Playlist]()
            
            if HTTPStatusCode == 200 && error == nil {
                do {
                    guard let  resultsDict = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary,
                                    items = resultsDict["items"] as? NSArray
                        else { fatalError() }
                    
                    let nextPageToken = resultsDict["nextPageToken"] as? String ?? "End"
                    print("NEXT")
                    print(nextPageToken)
                    
                    for i in 0...items.count - 1 {
                        guard let  itemDict = items[i] as? NSDictionary,
                                        snippet = itemDict["snippet"] as? NSDictionary,
                                        title = snippet["title"] as? String,
                                        thumbnail = snippet["thumbnails"] as? NSDictionary,
                                        defaults = thumbnail["default"] as? NSDictionary,
                                        thumbnailUrl = defaults["url"] as? String,
                                        resourceId = snippet["resourceId"] as? NSDictionary,
                                        videoId = resourceId["videoId"] as? String
                            else { fatalError() }
                        
                        playlistResult.append(Playlist(title: title, thumbnailUrl: thumbnailUrl, videoId: videoId))
                    }
                    
                    switch playlistType {
                    case .GameCrazy:
                        dispatch_async(dispatch_get_main_queue(), {
                            self.gamecrazyDelegate?.manager(self, playlistResult: playlistResult, nextPageToken: nextPageToken)
                        })
                        
                    case .Live:
                        dispatch_async(dispatch_get_main_queue(), {
                            self.liveDelegate?.manager(self, playlistResult: playlistResult, nextPageToken: nextPageToken)
                        })
                        
                    case .GameProducer:
                        dispatch_async(dispatch_get_main_queue(), {
                            self.gameproducerDelegate?.manager(self, playlistResult: playlistResult, nextPageToken: nextPageToken)
                        })
                        
                    case .VRGame:
                        dispatch_async(dispatch_get_main_queue(), {
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

    func searchVideo(keyword: String, vc: PlaylistType) {
        let urlString = "https://www.googleapis.com/youtube/v3/search?part=snippet&q=\(keyword)&channelId=\(channelId)&maxResults=\(20)&type=video&key=\(apiKey)"
        
        guard let searchUrl = NSURL(string: urlString)
            else {
                print("Error: NSURL gamecrazyUrl")
                return
        }
        
        performGetRequest(searchUrl, completion: { (data, HTTPStatusCode, error) -> Void in
            
            var searchResult = [Playlist]()
            
            if HTTPStatusCode == 200 && error == nil {
                do {
                    guard let  resultsDict = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary,
                        items = resultsDict["items"] as? NSArray
                        else { fatalError() }
                    
                    guard items.count != 0 else { return }
                    
                    for i in 0...items.count - 1 {
                        guard let  itemDict = items[i] as? NSDictionary,
                                        snippet = itemDict["snippet"] as? NSDictionary,
                                        title = snippet["title"] as? String,
                                        thumbnail = snippet["thumbnails"] as? NSDictionary,
                                        defaults = thumbnail["default"] as? NSDictionary,
                                        thumbnailUrl = defaults["url"] as? String,
                                        resourceId = itemDict["id"] as? NSDictionary,
                                        videoId = resourceId["videoId"] as? String
                            else { fatalError() }
                        
                        searchResult.append(Playlist(title: title, thumbnailUrl: thumbnailUrl, videoId: videoId))
                    }
                    
                    switch vc {
                    case .GameCrazy:
                        dispatch_async(dispatch_get_main_queue(), {
                            self.gamecrazySearchDelegate?.manager(self, searchResult: searchResult)
                        })
                        
                    case .Live:
                        dispatch_async(dispatch_get_main_queue(), {
                            self.liveSearchDelegate?.manager(self, searchResult: searchResult)
                        })
                        
                    case .GameProducer:
                        dispatch_async(dispatch_get_main_queue(), {
                            self.gameproducerSearchDelegate?.manager(self, searchResult: searchResult)
                        })
                        
                    case .VRGame:
                        dispatch_async(dispatch_get_main_queue(), {
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
    func manager(manager: YoutuberManager, playlistResult: [Playlist], nextPageToken: String)
}

protocol YoutuberManagerSearchDelegate: class {
    func manager(manager: YoutuberManager, searchResult: [Playlist])
}




