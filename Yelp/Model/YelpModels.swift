//
//  YelpModels.swift
//  YelpSearch
//
//  Created by HO, SCOTT on 11/8/17.
//  Copyright © 2017 Ho, Scott. All rights reserved.
//

import ObjectMapper



public class YelpBusiness: Mappable {
    public var id: String?
    public var name: String?
    public var imageUrl: URL?
    public var isClosed: Bool?
    public var url: URL?
    public var price: String?
    public var phone: String?
    public var displayPhone: String?
    public var photos: [String]?
    public var rating: Double?
    public var reviewCount: Int?
    public var distance: Double?
    public var coordinates: YelpCoordinates?
    public var location: YelpLocation?
    public var transactions: [String]?
    
    public required init?(map: Map) {
    }
    

    public func mapping(map: Map) {
        id              <- map["id"]
        name            <- map["name"]
        imageUrl        <- (map["image_url"], URLTransform())
        isClosed        <- map["is_closed"]
        url             <- (map["url"], URLTransform())
        price           <- map["price"]
        phone           <- map["phone"]
        displayPhone    <- map["display_phone"]
        photos          <- map["photos"]
        rating          <- map["rating"]
        reviewCount     <- map["review_count"]
        distance        <- map["distance"]
        coordinates     <- map["coordinates"]
        location        <- map["location"]
        transactions    <- map["transactions"]
    }
}

public class YelpCenter: Mappable {
    
    public var latitude: Double?
    public var longitude: Double?
    
    public required init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        latitude    <- map["latitude"]
        longitude   <- map["longitude"]
    }
}

public class YelpRegion: Mappable {
    
    public var center: YelpCenter?
    
    public required init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        center  <- map["center"]
    }
}

public class YelpOpen: Mappable {
    
    public var isOvernight: Bool?
    public var end: String?
    public var day: Int?
    public var start: String?
    
    public required init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        isOvernight <- map["is_overnight"]
        end         <- map["end"]
        day         <- map["day"]
        start       <- map["start"]
    }
}

public class YelpLocation: Mappable {
    
    public var addressOne: String?
    public var addressTwo: String?
    public var addressThree: String?
    public var city: String?
    public var state: String?
    public var zipCode: String?
    public var country: String?
    public var displayAddress: [String]?
    public var crossStreets: String?
    public required init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        addressOne      <- map["address1"]
        addressTwo      <- map["address2"]
        addressThree    <- map["address3"]
        city            <- map["city"]
        state           <- map["state"]
        zipCode         <- map["zip_code"]
        country         <- map["country"]
        displayAddress  <- map["display_address"]
        crossStreets    <- map["cross_streets"]
    }
}

public class YelpCoordinates: Mappable {

    public var latitude: Double?
    public var longitude: Double?

    public required init?(map: Map) {
    }

    public func mapping(map: Map) {
        latitude    <- map["latitude"]
        longitude   <- map["longitude"]
    }
}

public class YelpError: Mappable {
    
    public var description: String?
    public var field: String?
    public var code: String?
    
    public required init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        description <- map["description"]
        field       <- map["field"]
        code        <- map["code"]
    }
}
