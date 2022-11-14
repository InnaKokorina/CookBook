//
//  FavoriteModel.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 08.11.2022.
//

import Foundation

struct FavoriteModel: Equatable {
    let id: Int
    let title: String?
    let imagePath: String?
    var isliked: Bool? = true
    
    var imageURL: URL? {
        guard let imagePath = imagePath,
              let pathURL = URL(string: imagePath)
        else { return nil }
        return pathURL
    }
}
