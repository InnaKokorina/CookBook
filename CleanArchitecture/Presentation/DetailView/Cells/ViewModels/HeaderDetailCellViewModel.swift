//
//  HeaderDetailCellViewModel.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 14.10.2022.
//

import Foundation

struct HeaderDetailCellViewModel: DetailCellModelProtocol {
    let title: String?
    let imageURL: URL?
}
extension HeaderDetailCellViewModel {
    init(entity: DetailRecipes) {
        self.title = entity.title
        self.imageURL = entity.imageURL
    }
}
