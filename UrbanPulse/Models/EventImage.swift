//
//  EventImage.swift
//  UrbanPulse
//
//  Created by gaurvi singhal on 16/09/26.
//

import Foundation

struct EventImage: Codable{
    let ratio: String?
    let url: String
    let width: Int
    let height: Int
    let fallback: Bool
}

extension Array where Element == EventImage {
    var bestForHeroBanner: EventImage? {
        self.filter { $0.ratio == "16_9" }
            .max(by: { $0.width < $1.width })
    }
}
