//
//  Ticket.swift
//  UrbanPulse
//
//  Created by gaurvi singhal on 16/09/26.
//

import Foundation

struct Ticket {
    let id: String
    let eventId: String
    let eventName: String
    let venueName: String
    let eventDate: String
    let seatIds: [String]
    let totalPrice: Double
    let bookingDate: Date
    var qrCodeData: String {
        id
    }
}
