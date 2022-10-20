//
//  DishTypesCellViewModel.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 14.10.2022.
//

import Foundation

struct DishTypesCellViewModel: DetailCellModelProtocol {
    let types: [String]?
}

extension DishTypesCellViewModel {
    init(recipes: DetailRecipes) {
        self.types = recipes.dishTypes
    }
}
