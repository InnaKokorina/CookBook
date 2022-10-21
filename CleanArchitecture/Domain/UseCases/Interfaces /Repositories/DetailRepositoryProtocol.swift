//
//  DetailRepositoryProtocol.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 16.10.2022.
//

import Foundation

protocol FetchDetailRepositoryProtocol {
    func fetchDetailRepository(requestId: String, completion:  @escaping (Result<DetailRecipes, Error>) -> Void) -> Cancellable
}
