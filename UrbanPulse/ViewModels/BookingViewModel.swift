//
//  BookingViewModel.swift
//  UrbanPulse
//
//  Created by gaurvi singhal on 27/09/26.
//
import Foundation


final class BookingViewModel {
    let event: Event

    private(set) var quantities: [SeatCategory: Int] = [.standard: 0, .premium: 0, .vip: 0]

    init(event: Event) {
        self.event = event
    }

    func increment(_ category: SeatCategory) {
        quantities[category, default: 0] += 1
    }

    func decrement(_ category: SeatCategory) {
        guard let current = quantities[category], current > 0 else { return }
        quantities[category] = current - 1
    }

    var totalPrice: Double {
        quantities.reduce(0) { partial, entry in
            partial + (entry.key.basePrice * Double(entry.value))
        }
    }

    var totalSeatCount: Int {
        quantities.values.reduce(0, +)
    }
    
    func confirmBooking() -> Ticket? {
        guard totalSeatCount > 0 else { return nil }

        var seatIds: [String] = []
        for (category, count) in quantities where count > 0 {
            for i in 1...count {
                seatIds.append("\(category.rawValue.uppercased())-\(i)")
            }
        }

        let ticket = Ticket(
            id: UUID().uuidString,
            eventId: event.id,
            eventName: event.name,
            venueName: event.venue?.name ?? "Venue TBA",
            eventDate: event.dates.start.localDate,
            seatIds: seatIds,
            totalPrice: totalPrice,
            bookingDate: Date()
        )

        PersistenceManager.shared.saveTicket(ticket)  
        return ticket
    }
}
