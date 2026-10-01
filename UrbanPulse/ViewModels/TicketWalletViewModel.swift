//
//  TicketWalletViewModel.swift
//  UrbanPulse
//
//  Created by gaurvi singhal on 27/09/26.
//

final class TicketWalletViewModel {
    private(set) var tickets: [Ticket] = []

    func loadTickets() {
        tickets = PersistenceManager.shared.fetchAllTickets()
    }
}
