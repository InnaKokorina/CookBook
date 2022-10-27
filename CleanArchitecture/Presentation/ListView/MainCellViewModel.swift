//
//  MainCellViewModel.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 05.10.2022.
//

import Foundation

struct MainCellViewModel {
    let title: String?
    let imageURL: URL?
    let id: Int
}

extension MainCellViewModel {
    init(entity: Recipe) {
        self.title = entity.title
        self.imageURL = entity.imageURL
        self.id = entity.id
    }
}
