# UrbanPulse

A frontend-only iOS app for discovering live events, concerts, comedy shows, and nightlife — built entirely in programmatic UIKit (no Storyboards/XIBs) using the MVVM architecture.

Built as a technical showcase project targeting iOS Developer (SDE-1) roles.

## Features

- **Home Discovery Feed** — paging hero carousel, scrollable category pills, a "Trending Near You" rail, and a 2-column event grid, all in one `UICollectionView` using `UICollectionViewCompositionalLayout`
- **City Selector** — switch between cities; state is shared across Home and Search via a lightweight `AppState` singleton + `NotificationCenter`
- **Debounced Search** — real-time search with a 300ms debounce (via `Timer`), plus category-based filtering
- **Event & Venue Detail** — scrollable detail screen with a live `MapKit` venue pin, built on `UIScrollView` + Auto Layout
- **Booking Flow** — quantity-based ticket selection across pricing tiers (Standard / Premium / VIP) with a live running total
- **Local Persistence**
  - **CoreData** for booked tickets (structured, queryable data)
  - **UserDefaults** for bookmarked events (small, simple key-value data)
- **Digital Pass / QR Wallet** — tickets rendered with a real, scannable QR code generated natively via `CoreImage` (`CIFilter.qrCodeGenerator`), no third-party libraries
- **Pull-to-Refresh** on the Home feed

## Architecture

**MVVM**, strictly separated:
- **Model** — `Codable` structs matching the Ticketmaster Discovery API's real response shape, plus local-only models (`Seat`, `Ticket`)
- **ViewModel** — owns state (`ViewState<T>` enum: `.idle` / `.loading` / `.loaded` / `.error`), all networking calls, and all display-formatting logic
- **View** — `UIViewController`/`UIView` subclasses that only render what the ViewModel gives them; zero business logic

```
UrbanPulse/
├── App/                  AppDelegate, SceneDelegate, MainTabBarController
├── Core/
│   ├── Networking/       NetworkManager, Endpoint, NetworkError
│   ├── Cache/            ImageLoader (NSCache-backed)
│   ├── Storage/          PersistenceManager (CoreData), BookmarksManager (UserDefaults)
│   └── AppState.swift    Shared app-wide state (selected city)
├── Models/               Event, Venue, Seat, Ticket, and supporting Codable types
├── ViewModels/
├── Views/
│   ├── Home/
│   ├── Search/
│   ├── Detail/
│   ├── Booking/
│   ├── Wallet/
│   └── Favorites/
└── Resources/
```

## Key Technical Decisions

- **Classic `UICollectionViewDataSource`/`UITableViewDataSource`** (not diffable data sources) — a deliberate choice to stay close to patterns most commonly covered in technical interviews, at the cost of manual `reloadData()` calls instead of automatic diffing.
- **Seat selection simplified to a quantity-per-tier selector** rather than a spatial seat grid — same underlying pricing/state logic, lower complexity, since the project already demonstrates custom-grid UI elsewhere (Home feed).
- **Price filtering, where implemented, is client-side** — Ticketmaster's free API tier doesn't expose a documented server-side price-range parameter, so filtering happens on already-fetched results rather than via a new query param.
- **City selection defaults to a small, curated list of US cities** — Ticketmaster's event coverage doesn't include India; this was confirmed against their own API responses during development.

## Setup

1. Clone the repo.
2. Register for a free API key at the [Ticketmaster Developer Portal](https://developer.ticketmaster.com/).
3. Create `UrbanPulse/Core/Networking/APIConfig.swift` (gitignored, not included in this repo):
   ```swift
   enum APIConfig {
       static let ticketmasterAPIKey = "YOUR_KEY_HERE"
   }
   ```
4. Open `UrbanPulse.xcodeproj` and run on the iOS 18+ simulator.

## Known Limitations / Next Steps

- No price/date filter sheet UI yet (scoped, not built — client-side filtering approach was designed but deprioritized)
- No parallax effect on the Detail screen banner (static header currently)
- No unit tests yet — `NetworkManager` was built behind a `NetworkService` protocol specifically to make this possible without refactoring
- Seat-level booking is simulated (quantity-based), not a real spatial seat map, since no public API exposes real seat inventory

## Frameworks Used

UIKit, MapKit, CoreData, CoreImage, Foundation (URLSession, async/await) — no third-party dependencies.
