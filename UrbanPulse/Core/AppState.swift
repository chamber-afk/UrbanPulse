//
//  AppState.swift
//  UrbanPulse
//
//  Created by gaurvi singhal on 26/09/26.
//

import Foundation

extension Notification.Name {
    static let cityDidChange = Notification.Name("cityDidChange")
}

final class AppState {

    static let shared = AppState()
    private init() {}

    let availableCities: [String] = ["New York", "Los Angeles", "Chicago", "Miami", "Las Vegas"]

    private(set) var selectedCity: String = "Miami"

    func updateCity(_ city: String) {
        guard city != selectedCity else { return }
        selectedCity = city

        NotificationCenter.default.post(name: .cityDidChange, object: nil)
    }
}
