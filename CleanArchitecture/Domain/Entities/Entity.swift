//
//  Entity.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 04.10.2022.
//

import Foundation

struct Recipe: Equatable {
    let id: Int?
    let title: String?
    let posterPath: String?
}

struct RecipePage: Equatable {
    let offset: Int
    let totalResults: Int
    let recipes: [Recipe]
}

