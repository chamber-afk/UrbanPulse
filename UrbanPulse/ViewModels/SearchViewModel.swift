//
//  SearchViewModel.swift
//  UrbanPulse
//
//  Created by gaurvi singhal on 25/09/26.
//

import Foundation

final class SearchViewModel {

    var onStateChange: ((ViewState<[Event]>) -> Void)?

    private(set) var state: ViewState<[Event]> = .idle {
        didSet {
            onStateChange?(state)
        }
    }

    private var debounceTimer: Timer?
    private var lastQueryParams: [String: String] = [:]

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
        guard !lastQueryParams.isEmpty else { return }
        Task {
            await performSearch(queryParams: lastQueryParams)
        }
    }

    func selectCity(_ city: String) {
        AppState.shared.updateCity(city)
    }

    func searchTextDidChange(_ text: String) {
        debounceTimer?.invalidate()

        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            state = .idle
            lastQueryParams = [:]
            return
        }

        debounceTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { [weak self] _ in
            Task { [weak self] in
                await self?.performSearch(queryParams: ["keyword": trimmed])
            }
        }
    }

    func selectCategory(_ category: String) {
        debounceTimer?.invalidate()
        Task {
            await performSearch(queryParams: ["classificationName": category])
        }
    }

    private func performSearch(queryParams: [String: String]) async {
        lastQueryParams = queryParams
        state = .loading

        var fullParams = queryParams
        fullParams["apikey"] = APIConfig.ticketmasterAPIKey
        fullParams["countryCode"] = "US"
        fullParams["city"] = selectedCity
        fullParams["size"] = "20"

        let endpoint = Endpoint(
            baseURL: "https://app.ticketmaster.com",
            path: "/discovery/v2/events.json",
            queryParameters: fullParams
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
}
