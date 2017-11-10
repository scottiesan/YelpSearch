//
//  YelpOAuthCredential.swift
//  YelpSearch
//
//  Created by HO, SCOTT on 11/8/17.
//  Copyright © 2017 Ho, Scott. All rights reserved.
//

import ObjectMapper

class YelpOAuthCredential: Mappable {

    var accessToken: String?
    var expiresIn: Int?
    var tokenType: String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        accessToken <- map["access_token"]
        expiresIn   <- map["expires_in"]
        tokenType   <- map["token_type"]
    }
}
