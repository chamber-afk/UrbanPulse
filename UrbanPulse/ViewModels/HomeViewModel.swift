//
//  HomeViewModel.swift
//  UrbanPulse
//
//  Created by gaurvi singhal on 23/09/26.
//
import Foundation

final class HomeViewModel {

    var onStateChange: ((ViewState<[Event]>) -> Void)?

    private(set) var state: ViewState<[Event]> = .idle {
        didSet {
            onStateChange?(state)
        }
    }

    let categories: [String] = ["Music", "Comedy", "Nightlife", "Dining", "Festivals"]

    var availableCities: [String] { AppState.shared.availableCities }
    var selectedCity: String { AppState.shared.selectedCity }

    init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(cityDidChange),
            name: .cityDidChange,
            object: nil
        )
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func cityDidChange() {
        Task {
            await loadEvents()
        }
    }

    func selectCity(_ city: String) {
        AppState.shared.updateCity(city)
    }

    func loadEvents() async {
        state = .loading

        let endpoint = Endpoint(
            baseURL: "https://app.ticketmaster.com",
            path: "/discovery/v2/events.json",
            queryParameters: [
                "apikey": APIConfig.ticketmasterAPIKey,
                "city": selectedCity,
                "countryCode": "US",
                "size": "20"
            ]
        )

        do {
            let response: TicketmasterEventsResponse = try await NetworkManager.shared.fetch(endpoint)
            state = .loaded(response.events)
        } catch let error as NetworkError {
            state = .error(error)
        } catch {
            state = .error(.unknown)
        }
    }

    // MARK: - Derived data for each UI section

    var heroEvents: [Event] {
        guard case .loaded(let events) = state else { return [] }
        return Array(events.prefix(3))
    }

    var trendingEvents: [Event] {
        guard case .loaded(let events) = state else { return [] }
        return Array(events.dropFirst(3).prefix(6))
    }

    var gridEvents: [Event] {
        guard case .loaded(let events) = state else { return [] }
        return Array(events.dropFirst(9))
    }
}
