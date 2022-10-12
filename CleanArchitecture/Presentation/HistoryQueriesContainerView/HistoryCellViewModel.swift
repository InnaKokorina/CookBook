//
//  HistoryCellViewModel.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 12.10.2022.
//

import Foundation

struct HistoryCellViewModel {
    let title: String?
}
extension HistoryCellViewModel {
    init(entity: RecipeQuery) {
        self.title = entity.query
    }
}
