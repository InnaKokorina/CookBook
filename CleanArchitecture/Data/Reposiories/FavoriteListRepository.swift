//
//  FavoriteListRepository.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 07.11.2022.
//

import Foundation

final class FavoriteListRepository: FavoriteListRepositoryProtocol {
    let cache: RecipesListDataBaseStorageProtocol
    
    init (cache: RecipesListDataBaseStorageProtocol) {
        self.cache = cache
    }
    
    func fetchFavoriteFromDB(completion: @escaping (Result<[FavoriteModel]?, Error>) -> Void) {
        cache.fetchResponse {result in
            switch result {
            case .success(let recipes):
                completion(.success(recipes?.map { $0.toDomain() }))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func saveToFavoriteDB(selectedData: FavoriteModel, completion: @escaping (Error?) -> ()) {
        cache.save(selectedData: selectedData.toDTODB(), completion: completion)
    }
    
    func deleteFromFavoriteDB(selectedData: FavoriteModel, completion: @escaping (Error?) -> ()) {
        cache.delete(selectedData: selectedData.toDTODB(), completion: completion)
    }
    
    
}
