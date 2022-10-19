//
//  FetchDetailRecipeData.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 16.10.2022.
//

import Foundation

protocol FetchDetailUseCaseProtocol {
    func fetchDetail(requestId: String, completion:  @escaping (Result<DetailRecipes, Error>) -> Void) -> Cancellable?
}

final class FetchDetailUseCase: FetchDetailUseCaseProtocol {
    private let fetchDetailRepository: FetchDetailRepositoryProtocol
    
    init(fetchDetailRepository: FetchDetailRepositoryProtocol) {
        self.fetchDetailRepository = fetchDetailRepository
    }
    
    // MARK: - fetch details from repository
    func fetchDetail(requestId: String, completion:  @escaping (Result<DetailRecipes, Error>) -> Void) -> Cancellable? {
        fetchDetailRepository.fetchDetailRepository(requestId: requestId, completion: completion)
    }
}
