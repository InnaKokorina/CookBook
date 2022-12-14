//
//  SearchUseCase.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 04.10.2022.
//

import Foundation

protocol SearchUseCaseProtocol {
    func execute(request: SearchUseCaseRequestValue, offset: Int , completion: @escaping (Result<RecipePage, Error>) -> Void) -> Cancellable?
}

// MARK: - searchUseCase
final class SearchUseCase: SearchUseCaseProtocol {
    
    private let reposiories: ListReposioryProtocol
    private let historyReposiotry: HistoryListReposioryProtocol
    
    init(reposiories: ListReposioryProtocol, historyReposiory: HistoryListReposioryProtocol ) {
        self.reposiories = reposiories
        self.historyReposiotry = historyReposiory
    }
    
    // MARK: - execute from reposiories
    func execute(request: SearchUseCaseRequestValue, offset: Int, completion: @escaping (Result<RecipePage, Error>) -> Void) -> Cancellable? {
        return reposiories.fetchRepository(request: request.query, offset: offset, completion: { result in
            if case .success = result {
                self.historyReposiotry.saveHistoryQuery(query: request.query)
            }
            completion(result)
        })
    }
}
// MARK: - query
struct SearchUseCaseRequestValue {
    let query: RecipeQuery
}
