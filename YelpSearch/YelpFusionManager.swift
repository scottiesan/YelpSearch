//
//  YelpFusionManager.swift
//  YelpSearch
//
//  Created by HO, SCOTT on 11/6/17.
//  Copyright © 2017 Ho, Scott. All rights reserved.
//

import UIKit

class YelpFusionManager: NSObject {
    static let shared = YelpFusionManager()
    var apiClient: YelpFusionClient!
    
    func configure() {
        // How to authorize using your clientId and clientSecret
        self.apiClient = YelpFusionClient(clientId: "-O5LfavL_c-7pIM-oE3eng",
                                         clientSecret: "wqVLvizWNOPUI12A20Wabq6BfNTNS24Vx03LotXsY6OXWSZsGByqwxNT8ZCPrXTA")
    }
}
