//
//  ListRepository.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 06.10.2022.
//

import Foundation

final class ListRepository: ListReposioryProtocol {
    
    private let dataTransferService: DataTransferService
    private let cache: ResponseStorageProtocol
    
    init(dataTransferService: DataTransferService, cache: ResponseStorageProtocol) {
        self.dataTransferService = dataTransferService
        self.cache = cache
    }
    // MARK: - fetch data from cache or Network
    func fetchRepository(request: RecipeQuery, completion: @escaping (Result<Recipe, Error>) -> Void) -> Cancellable {
        
        let requestDTO = DataRequestDTO(query: request.query)
        let task = RepositoryTask()
        
        // fetch data from DB
     //   cache.getResponse(for: requestDTO) { result in
            // fetch from Nettwork
            let endpoint = ApiRequest.getData(with: requestDTO)
            print(endpoint)
            task.networkTask = self.dataTransferService.request(with: endpoint) {[weak self] result in
                
                switch result {
                case .success(let responseDTO):
                    // save to DB
                    self?.cache.save(response: responseDTO, for: requestDTO)
                    completion(.success(responseDTO.toDomain()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
      //  }
        return task
    }
}
