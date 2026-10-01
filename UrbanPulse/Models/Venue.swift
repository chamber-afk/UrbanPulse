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
    let postalCode: String?
    let timezone: String?
    let city: VenueCity?
    let state: VenueState?
    let country: VenueCountry?
    let address: VenueAddress?
    let location: VenueLocation?
}

struct VenueCity: Codable {
    let name: String
}

struct VenueState: Codable {
    let name: String?
    let stateCode: String?
}

struct VenueCountry: Codable {
    let name: String
    let countryCode: String
}

struct VenueAddress: Codable {
    let line1: String?
}

struct VenueLocation: Codable {
    let latitude: String
    let longitude: String
}
