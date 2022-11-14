//
//  FavoriteListRepositoryProtocol.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 07.11.2022.
//

import Foundation

protocol FavoriteListRepositoryProtocol {
    func fetchFavoriteFromDB(completion: @escaping (Result<[FavoriteModel]?, Error>) -> Void)
    func saveToFavoriteDB(selectedData: FavoriteModel, completion: @escaping (Error?) -> ())
    func deleteFromFavoriteDB(selectedData: FavoriteModel, completion: @escaping (Error?) -> ())
}
