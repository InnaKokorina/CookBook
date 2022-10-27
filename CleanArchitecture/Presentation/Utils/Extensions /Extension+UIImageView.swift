//
//  Extension+UIImageView.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 24.10.2022.
//

import Foundation
import UIKit
import Kingfisher

extension UIImageView {
    public func updateImage(url: URL) {
        let urlString = try? String(contentsOf: url)
        let processor = RoundCornerImageProcessor(cornerRadius: 15)
        let cache = ImageCache(name: urlString ?? "cachekey")
        cache.diskStorage.config.sizeLimit = 30 * 1024 * 1024
        cache.memoryStorage.config.totalCostLimit = 30 * 1024 * 1024
        cache.memoryStorage.config.expiration = .seconds(300)
        cache.diskStorage.config.expiration = .seconds(300)
        self.kf.indicatorType = .activity
        KF.url(url)
            .placeholder(UIImage(named: Constants.placeholderImage)!)
            .setProcessor(processor)
            .targetCache(cache)
            .scaleFactor(UIScreen.main.scale)
            .fade(duration: 1)
            .cacheOriginalImage()
            .onSuccess { result in
                print(result.source.cacheKey)
                print(result.cacheType)
                print(result.image.cacheCost)
                print(result.cacheType.cached)
            }
            .onFailure { error in
                print(error.localizedDescription)
            }
            .set(to: self)
    }
}

