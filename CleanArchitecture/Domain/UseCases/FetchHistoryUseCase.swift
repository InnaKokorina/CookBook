//
//  fetchRepositories.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 04.10.2022.
//

import Foundation

protocol FetchHisoryUseCaseProtocol {
    func start(completion:  @escaping (Result<[RecipeQuery], Error>) -> Void) 
}

final class FetchHistoryUseCase: FetchHisoryUseCaseProtocol {
   
    private let historyRepository: HistoryListReposioryProtocol
    
    init(historyRepository: HistoryListReposioryProtocol) {
        self.historyRepository = historyRepository
    }
    
    // MARK: - start fetch histories from repository
    func start(completion:  @escaping (Result<[RecipeQuery], Error>) -> Void) {
        historyRepository.fetchHistoryQueries(completion: completion)
    }
}
