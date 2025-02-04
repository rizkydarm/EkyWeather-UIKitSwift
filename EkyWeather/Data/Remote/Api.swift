//
//  Api.swift
//  EkyWeather
//
//  Created by Eky on 30/01/25.
//

import Foundation
import Alamofire

protocol Api {
    
    static var baseURL: String { get }
    var key: String { get }
    var headers: HTTPHeaders { get }
    
    func createEndpoint(path: String, method: HTTPMethod, query: Parameters?, body: Parameters?) -> Endpoint
}

class OpenMeteoApi: Api {
    
    static let baseURL: String = "https://api.open-meteo.com/v1/"
    
    let key: String = ""
    var headers: HTTPHeaders = [
        "Content-Type": "application/json"
    ]
    
    internal func createEndpoint(path: String,
                                 method: HTTPMethod,
                                 query: Parameters? = nil,
                                 body: Parameters? = nil) -> Endpoint {
        return Endpoint(
            baseURL: OpenMeteoApi.baseURL,
            headers: headers,
            path: path,
            method: method,
            query: query,
            body: body
        )
    }

}

class TmdbApi: Api {
    
    static let baseURL: String = "https://api.themoviedb.org/3/"
    
    let key: String = "f9786e6c408860d5243366d56f4565fb"
    var headers: HTTPHeaders = [
        "Content-Type": "application/json"
    ]
    
    init() {
        if let path = Bundle.main.path(forResource: "Secret", ofType: "plist") {
            if let dict = NSDictionary(contentsOfFile: path) as? [String: Any] {
                if let apiKey = dict["APIKEY"] as? String {
                    let value = "Bearer \(apiKey)"
                    headers.add(name: "Authorization", value: value)
                }
            }
        }
    }
    
    internal func createEndpoint(path: String,
                                 method: HTTPMethod,
                                 query: Parameters? = nil,
                                 body: Parameters? = nil) -> Endpoint {
        return Endpoint(
            baseURL: TmdbApi.baseURL,
            headers: headers,
            path: path,
            method: method,
            query: query,
            body: body
        )
    }
    
    enum ImageType {
        case original
        case w500
    }
    
    static func getImageURL(_ path: String, type: ImageType = .original) -> URL? {
        var typeStr = "original"
        switch type {
        case .w500:
            typeStr = "w500"
        default:
            break
        }
        return URL(string: "https://image.tmdb.org/t/p/\(typeStr)/\(path)")
    }
}
