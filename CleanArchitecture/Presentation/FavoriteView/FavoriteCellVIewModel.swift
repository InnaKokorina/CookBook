//
//  FavoriteCellVIewModel.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 08.11.2022.
//

import Foundation

struct FavoriteCellVIewModel {
    let title: String?
    let imageURL: URL?
    let id: Int
    var isLiked: Bool?
}

extension FavoriteCellVIewModel {
    init(entity: FavoriteModel) {
        self.title = entity.title
        self.imageURL = entity.imageURL
        self.id = entity.id
        self.isLiked = entity.isliked
    }
}

