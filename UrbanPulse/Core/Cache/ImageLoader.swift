//
//  ImageLoader.swift
//  UrbanPulse
//
//  Created by gaurvi singhal on 27/09/26.
//

import UIKit

final class ImageLoader {

    static let shared = ImageLoader()
    private init() {}

  
    private let cache = NSCache<NSString, UIImage>()

    func loadImage(from urlString: String) async -> UIImage? {
        let cacheKey = urlString as NSString

        if let cached = cache.object(forKey: cacheKey) {
            return cached
        }

        guard let url = URL(string: urlString) else { return nil }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else { return nil }

            cache.setObject(image, forKey: cacheKey)
            return image
        } catch {
            return nil
        }
    }
}
