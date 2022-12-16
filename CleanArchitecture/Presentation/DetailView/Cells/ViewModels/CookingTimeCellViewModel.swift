//
//  CookingTimeCellViewModel.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 14.11.2022.
//

import Foundation
struct CookingTimeCellViewModel: DetailCellModelProtocol {
    let cookingTime: Int?
}

extension CookingTimeCellViewModel {
    init(detailModel: DetailRecipes) {
        self.cookingTime = detailModel.cookingTime
    }
    
 func setStrokeEndValue() -> Float {
        let maxTime: Float = 120
        guard let cookingTime = cookingTime,
              Float(cookingTime) < maxTime  else { return 1.0 }
        return Float(cookingTime)  / maxTime
    }
}
