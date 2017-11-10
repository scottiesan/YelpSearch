//
//  YelpRouter.swift
//  YelpSearch
//
//  Created by HO, SCOTT on 11/6/17.
//  Copyright © 2017 Ho, Scott. All rights reserved.
//

import Alamofire

enum YelpRouter: URLRequestConvertible {
    
    case search(parameters: Parameters)
    case phone(parameters: Parameters)
    case transactions(type: String, parameters: Parameters)
    case business(id: String, parameters: Parameters)
    case reviews(id: String, parameters: Parameters)
    case autocomplete(parameters: Parameters)
    
    var method: HTTPMethod {
        switch self {
        case .search(parameters: _),
             .phone(parameters: _),
             .transactions(type: _, parameters: _),
             .business(id: _, parameters: _),
             .reviews(id: _, parameters: _),
             .autocomplete(parameters: _):
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .search(parameters: _):
            return "businesses/search"
        case .phone(parameters: _):
            return "businesses/search/phone"
        case .transactions(let type, parameters: _):
            return "transactions/\(type)/search"
        case .business(let id, parameters: _):
            return "businesses/\(id)"
        case .reviews(let id, parameters: _):
            return "businesses/\(id)/reviews"
        case .autocomplete(parameters: _):
            return "autocomplete"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try YelpURL.base.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        switch self {
        case .search(let parameters),
             .phone(let parameters),
             .transactions(type: _, let parameters),
             .business(id: _, let parameters),
             .reviews(id: _, let parameters),
             .autocomplete(let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        }
        
        return urlRequest
    }
}
