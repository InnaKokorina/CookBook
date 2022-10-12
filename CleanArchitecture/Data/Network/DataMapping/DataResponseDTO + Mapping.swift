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

// MARK: - maping to Domain
extension ResultResponseDTO {
    func toDomain() -> RecipePage {
        return .init (offset: offset, totalResults: totalResults, recipes: results.map { $0.toDomain()})
    }
}

extension DataResponseDTO {
    func toDomain() -> Recipe {
        return .init(id: id, title: title, posterPath: imageURL)
    }
}
