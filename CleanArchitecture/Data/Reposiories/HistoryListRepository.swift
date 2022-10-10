//
//  HistoryListRepository.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 06.10.2022.
//

import Foundation

final class HistoryListRepository: HistoryListReposioryProtocol {
    
    private let historyStorage: HistoryListStorageProtocol
    
    init(historyStorage: HistoryListStorageProtocol) {
        self.historyStorage = historyStorage
    }
    // MARK: - fetch/save history
    
    func fetchHistoryQueries(completion: @escaping (Result<[RecipeQuery], Error>) -> Void) {
        return historyStorage.fetchHistoryQueries(completion: completion)
    }
    
    func saveHistoryQuery(query: RecipeQuery, completion: @escaping (Result<RecipeQuery, Error>) -> Void) {
        return historyStorage.saveHistoryQuery(query: query, completion: completion)
    }
    
    
}
