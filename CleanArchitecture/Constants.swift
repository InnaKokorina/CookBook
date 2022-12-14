//
//  Constants.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 20.10.2022.
//

import Foundation

struct Constants {
    // MARK: - App Bundle
    static let apiKey = Bundle.main.infoDictionary?["API_KEY"] as? String
    static let apiKeyNumber = Bundle.main.infoDictionary?["ACCESS_KEY"] as? String
    static let baseURL = Bundle.main.infoDictionary?["BASE_URL"] as? String
    static let imageURL = Bundle.main.infoDictionary?["IMAGE_URL"] as? String
    static let path = Bundle.main.infoDictionary?["PATH"] as? String
    static let ingredientPath = Bundle.main.infoDictionary?["INGREDIENT_PATH"] as? String
   // MARK: - UI naming
    static let placeholderImage = "cooking"
    static let likeImage = "heart.fill"
    static let tabBarFirstImage = "house"
    static let tabBarSecondImage = "heart"
    static let tabBarFirstTitle = "Search"
    static let tabBarSecondTitle = "Favorite"
    // MARK: - Notificatin Center
    static let messageToFavorite = "updateFavorite"
    static let messageToMain = "updateMain"
}
