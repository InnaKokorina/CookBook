//
//  Entity.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 04.10.2022.
//

import Foundation

struct Recipe: Equatable {
    let id: Int
    let title: String?
    let imagePath: String?
    
    var imageURL: URL? {
        guard let imagePath = imagePath,
              let pathURL = URL(string: imagePath)
        else { return nil }
        return pathURL
    }
}

struct RecipePage: Equatable {
    let offset: Int
    let totalResults: Int
    let recipes: [Recipe]
}

