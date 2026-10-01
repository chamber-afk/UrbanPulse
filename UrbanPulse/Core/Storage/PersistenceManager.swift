//
//  PersistenceManager.swift
//  UrbanPulse
//
//  Created by gaurvi singhal on 27/09/26.
//
import Foundation
import CoreData

final class PersistenceManager {
    static let shared = PersistenceManager()
    private init() {}

    private lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "UrbanPulse")
        container.loadPersistentStores { _, error in
            if let error {
                print("CoreData failed to load: \(error)")
            }
        }
        return container
    }()

    // The scratchpad every operation below goes through.
    private var context: NSManagedObjectContext {
        container.viewContext
    }

    // MARK: - Create

    func saveTicket(_ ticket: Ticket) {
        let entity = TicketEntity(context: context)
        entity.id = ticket.id
        entity.eventId = ticket.eventId
        entity.eventName = ticket.eventName
        entity.venueName = ticket.venueName
        entity.eventDate = ticket.eventDate
        entity.seatIds = ticket.seatIds.joined(separator: ",")
        entity.totalPrice = ticket.totalPrice
        entity.bookingDate = ticket.bookingDate

        saveContext()
    }

    // MARK: - Read

    func fetchAllTickets() -> [Ticket] {
        let request = TicketEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "bookingDate", ascending: false)]   // newest first

        do {
            let entities = try context.fetch(request)
            return entities.map { entity in
                Ticket(
                    id: entity.id ?? "",
                    eventId: entity.eventId ?? "",
                    eventName: entity.eventName ?? "",
                    venueName: entity.venueName ?? "",
                    eventDate: entity.eventDate ?? "",
                    seatIds: (entity.seatIds ?? "").split(separator: ",").map(String.init),
                    totalPrice: entity.totalPrice,
                    bookingDate: entity.bookingDate ?? Date()
                )
            }
        } catch {
            print("CoreData fetch failed: \(error)")
            return []
        }
    }

    // MARK: - Save staged changes to disk

    private func saveContext() {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            print("CoreData save failed: \(error)")
        }
    }
}
