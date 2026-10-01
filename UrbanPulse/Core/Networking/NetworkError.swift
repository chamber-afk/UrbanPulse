//
//  NetworkError.swift
//  UrbanPulse
//
//  Created by gaurvi singhal on 15/09/26.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case requestFailed(underlying: Error)
    case badStatusCode(code: Int)
    case decodingFailed(underlying: Error)
    case unknown
}

extension NetworkError {
    var userMessage : String {
        switch self {
        case .invalidURL:
            return "Something went wrong building the request."
        case .requestFailed:
            return "Please check your internet connection and try again."
        case .badStatusCode(let code):
            return "Server returned an error (\(code))."
        case .decodingFailed:
            return "We received data in an unexpected format."
        case .unknown:
            return "An unexpected error occurred."
        }
    }
}
