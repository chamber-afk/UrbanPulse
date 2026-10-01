//
//  Event.swift
//  UrbanPulse
//
//  Created by gaurvi singhal on 16/09/26.
//

import Foundation

struct Event: Codable, Identifiable {
    let id: String
    let name: String
    let url: String?
    let images: [EventImage]
    let dates: EventDates
    let classifications: [Classification]?
    let priceRanges: [PriceRange]?
    let info: String?
    let pleaseNote: String?

    let embedded: EventEmbedded?

    enum CodingKeys: String, CodingKey {
        case id, name, url, images, dates, classifications, priceRanges, info, pleaseNote
        case embedded = "_embedded"
    }

    var venue: Venue? {
        embedded?.venues?.first
    }
}

struct EventEmbedded: Codable {
    let venues: [Venue]?
}
