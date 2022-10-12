//
//  Query.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 06.10.2022.
//

import Foundation

struct RecipeQuery {
    let query: String
    let offset: Int
}

extension RecipeQuery {
    func toDTO() -> DataRequestDTO {
        return .init(query: query, offset: offset)
    }
}
