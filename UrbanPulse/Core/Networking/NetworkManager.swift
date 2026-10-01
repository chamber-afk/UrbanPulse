//
//  NetworkManager.swift
//  UrbanPulse
//
//  Created by gaurvi singhal on 16/09/26.
//

import Foundation

protocol NetworkService {
    func fetch<T: Decodable>(_ endpoint : Endpoint) async throws -> T
}


final class NetworkManager : NetworkService {
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetch<T>(_ endpoint: Endpoint) async throws -> T where T : Decodable {
        guard let url = endpoint.buildURL() else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method
        
        
        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await URLSession.shared.data(for: request)
        } catch {
            throw NetworkError.requestFailed(underlying: error)
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.unknown
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.badStatusCode(code: httpResponse.statusCode)
        }
        
        do {
            let decoded = try JSONDecoder().decode(T.self, from: data)
            return decoded
        } catch {
            throw NetworkError.decodingFailed(underlying: error)
        }
    }
}


