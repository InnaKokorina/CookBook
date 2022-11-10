//
//  ListRepository.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 06.10.2022.
//

import Foundation

final class ListRepository: ListReposioryProtocol {
   
    var dataTransferService: DataTransferService?
    
    init(dataTransferService: DataTransferService) {
        self.dataTransferService = dataTransferService
    }
    // MARK: - fetch data from cache or Network
    func fetchRepository(request: RecipeQuery, offset: Int, completion: @escaping (Result<RecipePage, Error>) -> Void) -> Cancellable {
                let requestDTO = DataRequestDTO(query: request.query, offset: offset)
        let task = RepositoryTask()
    
            let endpoint = ApiRequest.getData(with: requestDTO)
            task.networkTask = self.dataTransferService?.request(with: endpoint) {[weak self] result in
                
                switch result {
                case .success(let responseDTO):
                    completion(.success(responseDTO.toDomain()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
      //  }
        return task
    }
}
