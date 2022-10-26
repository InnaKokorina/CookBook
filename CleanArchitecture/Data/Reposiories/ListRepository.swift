//
//  ListRepository.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 06.10.2022.
//

import Foundation

final class ListRepository: ListReposioryProtocol {
   
    var dataTransferService: DataTransferService?
    var cache: ResponseStorageProtocol? 
    
    init(dataTransferService: DataTransferService, cache: ResponseStorageProtocol) {
        self.dataTransferService = dataTransferService
        self.cache = cache
    }
    // MARK: - fetch data from cache or Network
    func fetchRepository(request: RecipeQuery, offset: Int, completion: @escaping (Result<RecipePage, Error>) -> Void) -> Cancellable {
                let requestDTO = DataRequestDTO(query: request.query, offset: offset)
        let task = RepositoryTask()
        
        //No fetch data from DB
     //   cache.getResponse(for: requestDTO) { result in
            // Just fetch from Network
        
            let endpoint = ApiRequest.getData(with: requestDTO)
            task.networkTask = self.dataTransferService?.request(with: endpoint) {[weak self] result in
                
                switch result {
                case .success(let responseDTO):
                    // save to DB
                    self?.cache?.save(response: responseDTO.results, for: requestDTO)
                    completion(.success(responseDTO.toDomain()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
      //  }
        return task
    }
}
