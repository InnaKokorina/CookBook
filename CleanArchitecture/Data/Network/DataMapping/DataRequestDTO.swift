//
//  DataMapping.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 06.10.2022.
//

import Foundation

struct DataRequestDTO: Encodable {
    let query: String
    let offset: Int
}

extension DataRequestDTO {
    func toDomain() -> RecipeQuery {
        return .init (query: query, offset: offset)
    }
}


