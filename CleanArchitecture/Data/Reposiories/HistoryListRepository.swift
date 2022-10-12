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
        return historyStorage.fetchHistoryQueries { result in
            switch result {
            case .success(let requestDTO):
                completion(.success(requestDTO.map {$0.toDomain()}))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func saveHistoryQuery(query: RecipeQuery) {
        return historyStorage.saveHistoryQuery(query: query.toDTO())
    } 
}
