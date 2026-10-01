//
//  Seat.swift
//  UrbanPulse
//
//  Created by gaurvi singhal on 16/09/26.
//

import Foundation

struct Seat: Codable, Identifiable {
    let id: String
    let row: String
    let number: Int
    let category: SeatCategory
    var isAvailable: Bool
    var isSelected: Bool = false
}

enum SeatCategory: String, Codable {
    case standard
    case premium
    case vip

    var basePrice: Double {
        switch self {
        case .standard: return 500
        case .premium: return 1200
        case .vip: return 2500
        }
    }
}

extension SeatCategory {
    var tagValue: Int {
        switch self {
        case .standard: return 0
        case .premium: return 1
        case .vip: return 2
        }
    }

    static func from(tag: Int) -> SeatCategory? {
        switch tag {
        case 0: return .standard
        case 1: return .premium
        case 2: return .vip
        default: return nil
        }
    }
}
