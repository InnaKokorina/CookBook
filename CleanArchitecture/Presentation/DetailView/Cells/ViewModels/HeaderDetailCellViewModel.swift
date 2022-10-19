//
//  HeaderDetailCellViewModel.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 14.10.2022.
//

import Foundation

struct HeaderDetailCellViewModel {
    let title: String?
    let imagePath: String?
}
extension HeaderDetailCellViewModel {
    init(entity: DetailRecipes) {
        self.title = entity.title
        self.imagePath = entity.imageUrl
    }
}
