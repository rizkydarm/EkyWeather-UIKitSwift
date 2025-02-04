//
//  ApiManager.swift
//  EkyWeather
//
//  Created by Eky on 30/01/25.
//

import Foundation
import Alamofire

class ApiManager {
    
    func request<T: Codable>(url: URLRequestConvertible, expecting type: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        AF.request(url)
            .validate()
            .responseDecodable(of: type.self) { response in
                switch response.result {
                case .success(let model):
                    completion(.success(model))
                case .failure(let error):
                    if let data = response.data {
                        let jsonString = String(data: data, encoding: .utf8)
                    }
                    completion(.failure(error))
                }
            }
        }
    
}
