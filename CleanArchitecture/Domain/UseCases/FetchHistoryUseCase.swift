//
//  fetchRepositories.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 04.10.2022.
//

import Foundation

protocol FetchHisoryUseCaseExecute {
    func start()
}

final class FetchHistoryUseCase: FetchHisoryUseCaseExecute {
    
    private let historyRepository: HistoryListReposioryProtocol
    private let completion: (Result<[RecipeQuery], Error>) -> Void
    
    init(historyRepository: HistoryListReposioryProtocol, completion: @escaping (Result<[RecipeQuery], Error>) -> Void) {
        self.historyRepository = historyRepository
        self.completion = completion
    }
    // MARK: - start fetch histories from repository
    func start() {
        historyRepository.fetchHistoryQueries(completion: completion)
    }
}
