//
//  TicketmasterEventsResponse.swift
//  UrbanPulse
//
//  Created by gaurvi singhal on 16/09/26.
//

import Foundation

struct TicketmasterEventsResponse: Codable {
    let embedded: ResponseEmbedded?
    let page: PageInfo?

    enum CodingKeys: String, CodingKey {
        case embedded = "_embedded"
        case page
    }

    var events: [Event] {
        embedded?.events ?? []
    }
}

struct ResponseEmbedded: Codable {
    let events: [Event]?
}

struct PageInfo: Codable {
    let size: Int
    let totalElements: Int
    let totalPages: Int
    let number: Int
}
