//
//  Endpoint.swift
//  UrbanPulse
//
//  Created by gaurvi singhal on 15/09/26.
//

import Foundation

struct Endpoint {
    let baseURL: String
    let path: String
    var queryParameters: [String: String] = [:]
    var method: String = "GET"
    
    func buildURL() -> URL? {
        var components = URLComponents(string: baseURL + path)
        
        components?.queryItems = queryParameters.map{
            URLQueryItem(name: $0.key, value: $0.value)
        }
        
        return components?.url
    }
}
