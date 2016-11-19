//
//  TwitterAPI.swift
//  TweetMashup
//
//  Created by Alex on 11/19/16.
//  Copyright © 2016 awol. All rights reserved.
//

import Foundation
import Alamofire
//import SwiftyJSON //won't import because precompiled to wrong version of swift


class TwitterAPI {
    
    fileprivate let baseUrl = URL(string: "https://api.twitter.com/")
    fileprivate let key =  "S2xmNUVJb2VRcUd2ZXRrOHhOSjRuUjNoWDpBcnp0TFIwM1VoQnpVNTRtSFNKRm9SczhtVXQ5em9jQkZSZ0lvTEl6dnVob2pIa0RxNQ=="
    fileprivate var bearerToken : String = ""
    
    init(){
        authenticate({})
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
            } catch let jsonError as Error {
                print(jsonError.localizedDescription)
            }
        }
    }
    
    
}