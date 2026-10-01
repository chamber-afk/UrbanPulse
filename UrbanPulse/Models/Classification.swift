//
//  Classification.swift
//  UrbanPulse
//
//  Created by gaurvi singhal on 16/09/26.
//

import Foundation

struct Classification: Codable {
    let primary: Bool
    let segment: ClassificationDetail?
    let genre: ClassificationDetail?
    let subGenre: ClassificationDetail?
}

struct ClassificationDetail: Codable {
    let id: String
    let name: String
}
