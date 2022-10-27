//
//  DetailEntity.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 14.10.2022.
//

import Foundation

struct DetailRecipes: Hashable {
    let id: Int
    let title: String?
    let imageUrlString: String?
    let extendedIngredients: [ExtendedIngredients]
    let dishTypes: [String]?
    
    var imageURL: URL? {
        guard let imagePath = imageUrlString,
              let pathURL = URL(string: imagePath) else { return nil }
        return pathURL
    }
}

struct ExtendedIngredients: Hashable {
    let id: Int
    let image: String?
    let name: String
    
    var ingredientsImageURL: URL? {
        guard let imageUrlString = Constants.imageURL,
              let path = Constants.ingredientPath,
              let image = image,
              let baseUrl = URL(string: imageUrlString) else { return nil }
        return baseUrl.appendingPathComponent(path + image)
    }
}
