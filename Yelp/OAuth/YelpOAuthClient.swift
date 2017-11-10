//
//  YelpDefaults.swift
//  YelpSearch
//
//  Created by HO, SCOTT on 11/8/17.
//  Copyright © 2017 Ho, Scott. All rights reserved.
//


import Alamofire
import AlamofireObjectMapper

struct YelpDefaults {
    static let accessToken = "YelpAccessToken"
    static let expiresIn = "YelpExpiresIn"
}

class YelpOAuthClient: NSObject {
    
    private let clientId: String!
    private let clientSecret: String!
    
    // MARK: - Initializers
    
    init(clientId: String!,
         clientSecret: String!) {
        assert((clientId != nil && clientId != "") &&
            (clientSecret != nil && clientSecret != ""), "Both a clientId and clientSecret are required to query the Yelp Fusion V3 Developers API oauth endpoint.")
        self.clientId = clientId
        self.clientSecret = clientSecret
    }
    
    // MARK: - Authorization Methods
    
    func authorize(completion: @escaping (Bool?, Error?) -> Void) {
        let params: Parameters = ["grant_type": "client_credentials",
                                  "client_id": self.clientId,
                                  "client_secret": self.clientSecret]
        Alamofire.request(YelpOAuthRouter.authorize(parameters: params)).responseObject { (response: DataResponse<YelpOAuthCredential>) in
            switch response.result {
            case .success(let oAuthCredential):
                let defaults = UserDefaults.standard
                // Save access token
                defaults.set(oAuthCredential.accessToken, forKey: YelpDefaults.accessToken)
                // Get current time in Int format
                let currentDate = Int(Date().timeIntervalSince1970)
                var expirationDate = currentDate
                if let expiresIn = oAuthCredential.expiresIn {
                    // Add the number of seconds until expiration
                    expirationDate = expirationDate + expiresIn - 86400
                }
                // Save the expiration time
                defaults.set(expirationDate, forKey: YelpDefaults.expiresIn)
                defaults.synchronize()
                completion(true, nil)
            case .failure(let error):
                print("authorize() failure: ", error.localizedDescription)
                completion(false, error)
            }
        }
    }
    
    func isAuthorized() -> Bool {
        let defaults = UserDefaults.standard
        if let _ = defaults.string(forKey: YelpDefaults.accessToken),
            self.isAuthorizationExpired() == false {
            return true
        } else {
            return false
        }
    }
    
    func isAuthorizationExpired() -> Bool {
        let defaults = UserDefaults.standard
        let expiresIn = defaults.integer(forKey: YelpDefaults.expiresIn)
        let expirationDate = Date(timeIntervalSince1970: TimeInterval(expiresIn))
        let currentDate = Date()
        if currentDate > expirationDate {
            return true
        } else {
            return false
        }
    }
    
    func accessToken() -> String? {
        let defaults = UserDefaults.standard
        if let accessToken = defaults.string(forKey: YelpDefaults.accessToken) {
            return accessToken
        } else {
            return nil
        }
    }
}
