//
//  EventDates.swift
//  UrbanPulse
//
//  Created by gaurvi singhal on 16/09/26.
//

import Foundation

struct EventDates: Codable {
    let start: EventStart
    let timezone: String?
    let status: EventStatus
}

struct EventStart: Codable {
    let localDate: String
    let localTime: String?
    let dateTime: String?
    let dateTBD: Bool
    let dateTBA: Bool
    let timeTBA: Bool
}

struct EventStatus: Codable {
    let code: String               // "onsale", "offsale", "cancelled", "postponed", "rescheduled"
}
