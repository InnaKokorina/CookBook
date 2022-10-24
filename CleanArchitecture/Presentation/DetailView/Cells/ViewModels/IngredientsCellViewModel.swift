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
    
    func setFullUrlString() -> String? {
        guard let imagePath = ingredientImagePath else { return nil }
        let path = "cdn/ingredients_250x250/\(imagePath)"
        let baseURL = Constants.imageURL ?? ""
        let urlString = baseURL + "/" + path
       return urlString
    }
}

extension IngredientsViewModel {
    init(ingredients: ExtendedIngredients) {
        self.ingredientName = ingredients.name
        self.ingredientImagePath = ingredients.image
    }
}
