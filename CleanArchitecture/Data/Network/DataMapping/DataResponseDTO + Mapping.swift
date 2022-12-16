//
//  DataResponseDTO.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 06.10.2022.
//

import Foundation
import UIKit

struct DataResponseDTO: Decodable {
    let id: Int?
    let title: String?
    let imageURL: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case imageURL = "image"
    }
}

struct ResultResponseDTO: Decodable {
    let results: [DataResponseDTO]
    let offset: Int
    let totalResults: Int
}

struct DetailResponseDTO: Decodable {
    let recipeId: Int
    let title: String?
    let imageUrl: String?
    let extendedIngredients: [ExtendedIngredientsDTO]
    let dishTypes: [String]?
    let cookingTime: Int?
    
    enum CodingKeys: String, CodingKey {
        case recipeId = "id"
        case title
        case imageUrl = "image"
        case extendedIngredients
        case dishTypes
        case cookingTime = "readyInMinutes"
    }
}

struct ExtendedIngredientsDTO: Decodable {
    let ingredientId: Int
    let inagedientImage: String?
    let inagedientName: String
    
    enum CodingKeys: String, CodingKey {
        case ingredientId = "id"
        case inagedientImage = "image"
        case inagedientName = "name"
    }
}

// MARK: - maping to Domain
extension ResultResponseDTO {
    func toDomain() -> RecipePage {
        return .init (offset: offset, totalResults: totalResults, recipes: results.map { $0.toDomain()})
    }
}

extension DataResponseDTO {
    func toDomain() -> Recipe {
        return .init(id: id ?? 0, title: title, imagePath: imageURL)
    }
}

extension ExtendedIngredientsDTO {
    func toDomain() -> ExtendedIngredients {
        return .init(id: ingredientId, image: inagedientImage, name: inagedientName)
    }
}

extension DetailResponseDTO {
    func toDomain() -> DetailRecipes {
        return .init(id: recipeId, title: title, imageUrlString: imageUrl, extendedIngredients: extendedIngredients.map { $0.toDomain() }, dishTypes: dishTypes, cookingTime: cookingTime)
    }
}


