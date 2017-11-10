//
//  Parameters+SearchParamaters.swift
//  YelpSearch
//
//  Created by HO, SCOTT on 11/9/17.
//  Copyright © 2017 Ho, Scott. All rights reserved.
//


import Alamofire

extension Dictionary where Key: ExpressibleByStringLiteral, Value: Any {
    
    static func searchParameters(withTerm term: String?,
                                 location: String?,
                                 latitude: Double?,
                                 longitude: Double?,
                                 radius: Int?,
                                 limit: Int?,
                                 offset: Int?,
                                 attributes: [YelpAttributeFilter]?) -> Parameters{
        
        var params: Parameters = [:]
        
        if let term = term,
            term != "" {
            params["term"] = term
        }
        if let location = location,
            location != "" {
            params["location"] = location
        }
        if let latitude = latitude {
            params["latitude"] = latitude
        }
        if let longitude = longitude {
            params["longitude"] = longitude
        }
        if let radius = radius {
            params["radius"] = radius
        }
        if let limit = limit {
            params["limit"] = limit
        }
        if let offset = offset {
            params["offset"] = offset
        }
        return params
    }
}
