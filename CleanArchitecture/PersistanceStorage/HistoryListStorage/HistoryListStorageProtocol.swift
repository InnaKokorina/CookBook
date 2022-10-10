//
//  HistoryListStorageProtocol.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 06.10.2022.
//

import Foundation

protocol HistoryListStorageProtocol {
    func fetchHistoryQueries(completion: @escaping (Result<[RecipeQuery], Error>) -> Void)
    func saveHistoryQuery(query: RecipeQuery, completion: @escaping (Result<RecipeQuery, Error>) -> Void)
}
