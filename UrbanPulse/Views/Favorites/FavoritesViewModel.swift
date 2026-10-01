//
//  FavoritesViewModel.swift
//  UrbanPulse
//
//  Created by gaurvi singhal on 27/09/26.
//

final class FavoritesViewModel {
    private(set) var events: [Event] = []

    func loadBookmarks() {
        events = BookmarksManager.shared.getAllBookmarks()
    }
}
