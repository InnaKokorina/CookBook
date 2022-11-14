//
//  DataBaseDataDTO + Mapping.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 03.11.2022.
//

import Foundation
import CoreData

struct DataBaseResponseDTO {
    let id: Int
    let title: String?
    let imageURL: String?
    let isLiked: Bool?
}

extension DataBaseResponseDTO {
    func toDomain() -> FavoriteModel {
        return .init(id: id,
                     title: title,
                     imagePath: imageURL,
                     isliked: isLiked)
    }
}

// MARK: - CoreData to DTO
extension RecipesCoreDataModel {
    func toDTO() -> DataBaseResponseDTO {
        return .init(id: Int(id),
                     title: title,
                     imageURL: imagePath,
                     isLiked: isLiked)
    }
}

// MARK: - DTO to CoreData
extension DataBaseResponseDTO {
    func toCoreDataEntity(in context: NSManagedObjectContext) -> RecipesCoreDataModel {
        let coreDataEntity: RecipesCoreDataModel = .init(context: context)
        coreDataEntity.id = Int64(id)
        coreDataEntity.title = title
        coreDataEntity.imagePath = imageURL
        coreDataEntity.isLiked = isLiked ?? false
        return coreDataEntity
    }
}
// MARK: - Domain to DTODB
extension FavoriteModel {
    func toDTODB() -> DataBaseResponseDTO {
        return .init(id: Int(id),
                     title: title,
                     imageURL: imagePath,
                     isLiked: isliked)
    }
}


