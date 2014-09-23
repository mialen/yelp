//
//  YelpService.swift
//  yelp
//
//  Created by Alena Nikitina on 9/19/14.
//  Copyright (c) 2014 Alena Nikitina. All rights reserved.
//

import UIKit

class YelpService: BDBOAuth1RequestOperationManager {
    var accessToken: String!
    var accessSecret: String!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(consumerKey key: String!, consumerSecret secret: String!, accessToken: String!, accessSecret: String!) {
        self.accessToken = accessToken
        self.accessSecret = accessSecret
        var baseUrl = NSURL(string: "http://api.yelp.com/v2/")
        super.init(baseURL: baseUrl, consumerKey: key, consumerSecret: secret);
        
        var token = BDBOAuthToken(token: accessToken, secret: accessSecret, expiration: nil)
        self.requestSerializer.saveAccessToken(token)
    }
    
    func searchWithTerm(params: [String: String], success: (AFHTTPRequestOperation!, AnyObject!) -> Void, failure: (AFHTTPRequestOperation!, NSError!) -> Void) -> AFHTTPRequestOperation! {
            var parameters = params
            if params["location"] == nil || params["location"] == "" {
                parameters["location"] = "San Jose"
            }
        
            if params["term"] == nil || params["term"] == "" {
                parameters["term"] = "Restaurants"
            }
        return self.GET("search", parameters: parameters, success: success, failure: failure)
    }
}