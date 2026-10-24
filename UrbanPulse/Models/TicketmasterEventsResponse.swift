//
//  TicketmasterEventsResponse.swift
//  UrbanPulse
//
//  Created by gaurvi singhal on 16/09/26.
//

import Foundation

struct TicketmasterEventsResponse: Codable {
    let embedded: ResponseEmbedded?

    enum CodingKeys: String, CodingKey {
        case embedded = "_embedded"
    }

    var events: [Event] {
        embedded?.events ?? []
    }
}

struct ResponseEmbedded: Codable {
    let events: [Event]?
}

