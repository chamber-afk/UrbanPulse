//
//  PriceRange.swift
//  UrbanPulse
//
//  Created by gaurvi singhal on 16/09/26.
//

import Foundation

struct PriceRange: Codable {
    let currency: String
    let min: Double
    let max: Double
}
