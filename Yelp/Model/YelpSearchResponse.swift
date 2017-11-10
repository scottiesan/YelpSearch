//
//  YelpSearchResponse.swift
//  YelpSearch
//
//  Created by HO, SCOTT on 11/8/17.
//  Copyright © 2017 Ho, Scott. All rights reserved.
//

import ObjectMapper

class YelpSearchResponse: Mappable {
    
    public var total: Int?
    public var businesses: [YelpBusiness]?
    public var region: YelpRegion?
    public var error: YelpError?
    
    public required init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        total           <- map["total"]
        businesses      <- map["businesses"]
        region          <- map["region"]
        error           <- map["error"]
    }
}
