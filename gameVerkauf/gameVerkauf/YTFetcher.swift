//
//  YTFetcher.swift
//  gameVerkauf
//
//  Created by Adam Mahmoud on 21.06.17.
//
//

import Foundation
import UIKit


class YTFetcher{
    
    static let shared = YTFetcher()
    
    let API_KEY:String = "AIzaSyD0hMgwIcVNQh-VIyymjPo5Ul_vUOTE5hQ"
    
    enum YTVideoType:String{
        
        case Trailer
        case Gameplay
    }
    
    func getRequest(name: String, console: String, type: YTVideoType) {
        let type_string = type.rawValue
        let KEYWORDS = "\(name) \(console) \(type_string)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let BASE_URL = "https://www.googleapis.com/youtube/v3/"
        
        let SEARCH = "search?part=snippet&q=\(KEYWORDS)&maxResults=1&order=relevance&key=\(API_KEY)"
        
        let FULL_URL = BASE_URL+SEARCH
        let task = URLSession.shared.dataTask(with: URL(string: FULL_URL)!) {data, response, error in
            guard error == nil else{
                print(error!)
                return
            }
            guard let data = data else{
                print ("Data is empty")
                return
            }
            
            
            let json = try? JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            let items = json?["items"] as! [[String: Any]]
            let id = items[0]["id"] as! [String: Any]
            let videoID  = id["videoId"] as? String
            
            if videoID != nil {
                //pass videoID
                print(videoID!)
                NotificationsController.videoIDFound(videoID!)
                
            }
            else{
                
                NotificationsController.videoIDNotFound()
            }
        }
        
        task.resume()
        
    }
    
    
    
}
