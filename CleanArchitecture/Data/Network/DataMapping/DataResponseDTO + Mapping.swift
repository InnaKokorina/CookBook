//
//  DataResponseDTO.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 06.10.2022.
//

import Foundation
import UIKit

//DTO for API Request
struct DataResponseDTO: Decodable {
    let id: String
    let title: String
    let imageURL: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case imageURL = "image"
    }
}
// а нужна ли структура с результатами?
struct ResultResponseDTO: Decodable {
    let results: [DataResponseDTO]
}

// MARK: - maping to Domain
extension DataResponseDTO {
    func toDomain() -> Recipe {
        return .init(id: id, title: title, posterPath: imageURL)
    }
}
