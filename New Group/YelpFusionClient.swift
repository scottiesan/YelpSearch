//
//  YelpFusionClient.swift
//  YelpSearch
//
//  Created by HO, SCOTT on 11/6/17.
//  Copyright © 2017 Ho, Scott. All rights reserved.
//

import Alamofire
import AlamofireObjectMapper


class YelpFusionClient: NSObject {

    private let oAuthClient: YelpOAuthClient!

    private lazy var manager: Alamofire.SessionManager = {
        if let accessToken = self.oAuthClient.accessToken() {
            // Configuration
            let configuration = URLSessionConfiguration.default

            var headers = Alamofire.SessionManager.defaultHTTPHeaders
            // Authorization header
            headers["Authorization"] = "Bearer \(accessToken)"
            configuration.httpAdditionalHeaders = headers

            // Caching
            configuration.requestCachePolicy = .returnCacheDataElseLoad
            let memoryCapacity = 100 * 1024 * 1024;
            let diskCapacity = 100 * 1024 * 1024;
            let cache = URLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity, diskPath: "shared_cache")
            configuration.urlCache = cache
            
            // Create a session manager with the custom configuration
            return Alamofire.SessionManager(configuration: configuration)
        } else {
            return Alamofire.SessionManager()
        }
    }()

    public init(clientId: String!,
                clientSecret: String!) {
        assert((clientId != nil && clientId != "") &&
            (clientSecret != nil && clientSecret != ""), "Both a clientId and clientSecret are required to query the Yelp Fusion V3 Developers API oauth endpoint.")
        self.oAuthClient = YelpOAuthClient(clientId: clientId,
                                             clientSecret: clientSecret)
        super.init()
        self.authenticate()
    }
    
    private func authenticate() {
        if self.oAuthClient.isAuthorized() == false {
            self.oAuthClient.authorize { (successful, error) in
                
                if let error = error {
                    print("authorize() failure: ", error.localizedDescription)
                }
            }
        }
    }
    
    public func isAuthenticated() -> Bool {
        return self.oAuthClient.isAuthorized()
    }
    
    public func searchBusinesses(byTerm term: String?,
                                 location: String?,
                                 latitude: Double?,
                                 longitude: Double?,
                                 radius: Int?,
                                 locale: YelpLocale?,
                                 limit: Int?,
                                 offset: Int?,
                                 attributes: [YelpAttributeFilter]?,
                                 completion: @escaping (YelpSearchResponse?, Error?) -> Void) {

        if self.isAuthenticated() == true {
            
            let params = Parameters.searchParameters(withTerm: term,
                                                     location: location,
                                                     latitude: latitude,
                                                     longitude: longitude,
                                                     radius: radius,
                                                     limit: limit,
                                                     offset: offset,
                                                     attributes: attributes)
            
            self.manager.request(YelpRouter.search(parameters: params)).responseObject { (response: DataResponse<YelpSearchResponse>) in
                
                switch response.result {
                case .success(let searchResponse):
                    completion(searchResponse, nil)
                case .failure(let error):
                    print("searchBusinesses(byTerm) failure: ", error.localizedDescription)
                    completion(nil, error)
                }
            }
        }
    }

    public func cancelAllPendingAPIRequests() {
        self.manager.session.getTasksWithCompletionHandler { (dataTasks, uploadTasks, downloadTasks) in
            dataTasks.forEach { $0.cancel() }
            uploadTasks.forEach { $0.cancel() }
            downloadTasks.forEach { $0.cancel() }
        }
    }
}

