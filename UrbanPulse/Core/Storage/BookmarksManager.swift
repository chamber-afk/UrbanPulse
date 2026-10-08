//
//  BookmarksManager.swift
//  UrbanPulse
//
//  Created by gaurvi singhal on 27/09/26.
//

import Foundation

final class BookmarksManager {
    static let shared = BookmarksManager()
    private init() {}

    private let defaults = UserDefaults.standard
    private let key = "bookmarkedEvents"

    func getAllBookmarks() -> [Event] {
        guard let data = defaults.data(forKey: key) else { return [] }
        guard let events = try? JSONDecoder().decode([Event].self, from: data) else { return [] }
        return events
    }

    func isBookmarked(_ eventId: String) -> Bool {
        getAllBookmarks().contains { $0.id == eventId }
    }

    func toggleBookmark(_ event: Event) {
        var current = getAllBookmarks()
        if let index = current.firstIndex(where: { $0.id == event.id }) {
            current.remove(at: index)
        } else {
            current.append(event)     
        }
        save(current)
    }

    private func save(_ events: [Event]) {
        guard let data = try? JSONEncoder().encode(events) else { return }
        defaults.set(data, forKey: key)  
    }
}
