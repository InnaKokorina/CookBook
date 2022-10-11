//
//  SearchUseCase.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 04.10.2022.
//

import Foundation

protocol SearchUseCaseExecute {
    func execute(request: SearchUseCaseRequestValue, completion: @escaping (Result<RecipePage, Error>) -> Void) -> Cancellable?
}

// MARK: - searchUseCase
final class SearchUseCase: SearchUseCaseExecute {
    
    private let reposiories: ListReposioryProtocol
    private let historyReposiotry: HistoryListReposioryProtocol
    
    init(reposiories: ListReposioryProtocol, historyReposiory: HistoryListReposioryProtocol ) {
        self.reposiories = reposiories
        self.historyReposiotry = historyReposiory
    }
    
    // MARK: - execute from reposiories
    func execute(request: SearchUseCaseRequestValue, completion: @escaping (Result<RecipePage, Error>) -> Void) -> Cancellable? {
        return reposiories.fetchRepository(request: request.query, completion: { result in
            if case .success = result {
                self.historyReposiotry.saveHistoryQuery(query: request.query) { _ in }
            }
            completion(result)
        })
    }
}
// MARK: - query
struct SearchUseCaseRequestValue {
    let query: RecipeQuery
}
