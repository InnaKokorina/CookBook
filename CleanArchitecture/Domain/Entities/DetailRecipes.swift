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
    let imageUrl: String?
    let extendedIngredients: [ExtendedIngredients]
    let dishTypes: [String]?
}

struct ExtendedIngredients: Hashable {
    let id: Int
    let image: String?
    let name: String
}
