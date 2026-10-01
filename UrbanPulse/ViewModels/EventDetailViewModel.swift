//
//  EventDetailViewModel.swift
//  UrbanPulse
//
//  Created by gaurvi singhal on 27/09/26.
//

import Foundation

final class EventDetailViewModel {

    let event: Event

    init(event: Event) {
        self.event = event
    }

    // MARK: - Formatted, display-ready values

    var title: String { event.name }

    var formattedDate: String {
        event.dates.start.localTime != nil
            ? "\(event.dates.start.localDate) at \(event.dates.start.localTime!)"
            : event.dates.start.localDate
    }

    var statusText: String {
        event.dates.status.code.capitalized
    }

    var description: String {
        event.info ?? event.pleaseNote ?? "No additional details provided for this event."
    }

    var priceText: String {
        guard let range = event.priceRanges?.first else { return "Price unavailable" }
        return "\(range.currency) \(Int(range.min)) - \(Int(range.max))"
    }

    var venue: Venue? {
        event.venue
    }

    var bannerImageURL: String? {
        event.images.bestForHeroBanner?.url ?? event.images.first?.url
    }
}
