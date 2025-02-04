//
//  Endpoint.swift
//  EkyWeather
//
//  Created by Eky on 30/01/25.
//

import Foundation
import Alamofire

struct Endpoint: URLRequestConvertible {
    
    var baseURL: String
    var headers: HTTPHeaders
    
    var path: String
    var method: HTTPMethod
    
    var query: Parameters?
    var body: Parameters?
    
    func asURLRequest() throws -> URLRequest {
        
        let url = try baseURL.asURL().appendingPathComponent(path)
        var urlRequest = URLRequest(url: url)
        
        urlRequest.method = method
        headers.forEach { header in
            urlRequest.setValue(header.value, forHTTPHeaderField: header.name)
        }
        
        if let encodedQuery = try? URLEncoding.queryString.encode(urlRequest, with: query) {
            urlRequest = encodedQuery
        }
        
        if let encodedBody = try? JSONEncoding.default.encode(urlRequest, with: body) {
            urlRequest = encodedBody
        }
        
        return urlRequest
    }
    
}
