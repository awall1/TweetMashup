//
//  TwitterAPI.swift
//  TweetMashup
//
//  Created by Alex on 11/19/16.
//  Copyright © 2016 awol. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON //won't import because precompiled to wrong version of swift

struct Tweet {
    var message : String
    var user : String
    
    init() {
        message = ""
        user = ""
    }
}

enum SearchResult {
    case success([Tweet])
    case failure
}



class TwitterAPI {
    
    static let sharedInstance = TwitterAPI()
    
    fileprivate let baseUrl = URL(string: "https://api.twitter.com/")
    fileprivate let key =  "S2xmNUVJb2VRcUd2ZXRrOHhOSjRuUjNoWDpBcnp0TFIwM1VoQnpVNTRtSFNKRm9SczhtVXQ5em9jQkZSZ0lvTEl6dnVob2pIa0RxNQ=="
    fileprivate var bearerToken : String = ""
    
    init(){
        authenticate({})
    }
    
    func search(query: String, completion: @escaping (SearchResult)->()) {
        let headers = ["Authorization":"Bearer \(bearerToken)"]
        let parameters: Parameters = ["q" : query]
        
        Alamofire.request((baseUrl?.appendingPathComponent("1.1/search/tweets.json"))!, parameters: parameters, headers: headers).responseJSON{
            [weak self] (response: Alamofire.DataResponse<Any>) -> Void in
            print(request)

            
            guard let _self = self, let data = response.data else {
                return
            }
            
            let json = JSON(data: data)
            var tweetArray : [Tweet] = []
            
            for (key,subJson):(String, JSON) in  json["statuses"] {
                print("Key: \(key)\nSubJson: \(subJson)")
                
                var tweet = Tweet()
                
                guard   let message = subJson["text"].string,
                        let user = subJson["user"]["name"].string
                else{
                    completion(.failure)
                        return
                }
                tweet.message = message
                tweet.user = user
                tweetArray.append(tweet)
            }
            completion(.success(tweetArray))
        }
    }
    
    func authenticate(_ completion: @escaping () -> Void) {
        let headers: HTTPHeaders = ["Authorization":"Basic \(key)",
            "Content-Type":"application/x-www-form-urlencoded;charset=UTF-8"]
        let parameters: Parameters = ["grant_type":"client_credentials"]
        
        Alamofire.request((baseUrl?.appendingPathComponent("oauth2/token"))!, method: .post, parameters: parameters, headers: headers).responseJSON{
            [weak self] (response: Alamofire.DataResponse<Any>) -> Void in
            print(request)
            guard let _self = self else {
                return
            }
            
            print(response)
            
            do {
                if let data = response.data, let jsonResult = try JSONSerialization.jsonObject(with: data) as? NSDictionary {
                    print(jsonResult["access_token"]!)
                    _self.bearerToken = jsonResult["access_token"] as! String
                    completion()
                }
            } catch let jsonError {
                print(jsonError.localizedDescription)
            }
        }
    }
    
    
}
