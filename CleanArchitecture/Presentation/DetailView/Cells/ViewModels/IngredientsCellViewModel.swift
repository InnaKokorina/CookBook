//
//  IngredientsCellViewModel.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 14.10.2022.
//

import Foundation

struct IngredientsViewModel: DetailCellModelProtocol {
    let ingredientImagePath: String?
    let ingredientName: String
}

extension IngredientsViewModel {
    init(ingredients: ExtendedIngredients) {
        self.ingredientName = ingredients.name
        self.ingredientImagePath = ingredients.image
    }
}
