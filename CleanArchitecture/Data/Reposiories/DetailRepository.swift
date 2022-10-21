//
//  DetailRepository.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 16.10.2022.
//

import Foundation

final class DetailRepository: FetchDetailRepositoryProtocol {
    
    private let dataTransferService: DataTransferService
    
    init(dataTransferService: DataTransferService) {
        self.dataTransferService = dataTransferService
    }
    
    func fetchDetailRepository(requestId: String, completion: @escaping (Result<DetailRecipes, Error>) -> Void) -> Cancellable {
        let requestDetailDTO = DetailRequestDTO(recipeId: requestId)
        let task = RepositoryTask()
        let endpoint = ApiRequest.getDetail(with: requestDetailDTO)
        task.networkTask = self.dataTransferService.request(with: endpoint) { result in
            switch result {
            case .success(let responseDTO):
                completion(.success(responseDTO.toDomain()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        return task
    }
}
