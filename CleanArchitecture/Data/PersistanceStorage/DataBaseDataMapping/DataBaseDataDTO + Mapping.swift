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

//struct ResultDataBaseResponseDTO {
//    let results: [DataBaseResponseDTO]
//    let offset: Int?
//    let totalResults: Int?
//}
// MARK: - DTO to Domain
//extension ResultDataBaseResponseDTO {
//    func toDomain() -> RecipePage? {
//        return .init(offset: offset,
//                     totalResults: totalResults,
//                     recipes: results.map { $0.toDomain() })
//    }
//}

extension DataBaseResponseDTO {
    func toDomain() -> FavoriteModel {
        return .init(id: id,
                     title: title,
                     imagePath: imageURL,
                     isliked: isLiked)
    }
}

// MARK: - CoreData to DTO
//extension ResultCoreDataModel {
//    func toDTO() -> ResultDataBaseResponseDTO {
//        return .init(results: recipes?.allObjects.map { ($0 as! RecipesCoreDataModel).toDTO() } ?? [],
//                     offset: Int(offset),
//                     totalResults: Int(totalResult))
//    }
//}

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


