//
//  Venue.swift
//  UrbanPulse
//
//  Created by gaurvi singhal on 16/09/26.
//

import Foundation

struct Venue: Codable {
    let id: String
    let name: String
    let city: VenueCity?
    let address: VenueAddress?
    let location: VenueLocation?
}

struct VenueCity: Codable {
    let name: String
}

struct VenueAddress: Codable {
    let line1: String?
}

struct VenueLocation: Codable {
    let latitude: String
    let longitude: String
}
