//
//  EventDates.swift
//  UrbanPulse
//
//  Created by gaurvi singhal on 16/09/26.
//

import Foundation

struct EventDates: Codable {
    let start: EventStart
    let status: EventStatus
}

struct EventStart: Codable {
    let localDate: String
    let localTime: String?
}

struct EventStatus: Codable {
    let code: String               // "onsale", "offsale", "cancelled", "postponed", "rescheduled"
}
