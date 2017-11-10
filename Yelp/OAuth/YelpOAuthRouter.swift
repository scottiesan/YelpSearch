//
//  YelpOAuthRouter.swift
//  YelpSearch
//
//  Created by HO, SCOTT on 11/8/17.
//  Copyright © 2017 Ho, Scott. All rights reserved.
//
import Alamofire

enum YelpOAuthRouter: URLRequestConvertible {    
    case authorize(parameters: Parameters)
    var method: HTTPMethod {
        switch self {
        case .authorize(parameters: _):
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .authorize(parameters: _):
            return "oauth2/token"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try YelpURL.oAuth.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        switch self {
        case .authorize(let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        }
        
        return urlRequest
    }
}
