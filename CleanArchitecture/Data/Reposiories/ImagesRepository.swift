//
//  ImagesRepository.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 11.10.2022.
//

import Foundation

final class ImagesRepository {
    
    private let dataTransferService: DataTransferService

    init(dataTransferService: DataTransferService) {
        self.dataTransferService = dataTransferService
    }
}

extension ImagesRepository: ImagesRepositoryPrototcol {
    func fetchImage(with imagePath: String, completion: @escaping (Result<Data, Error>) -> Void) -> Cancellable? {
        let endpoint = ApiRequest.getImages(path: imagePath)
        let task = RepositoryTask()
        
        task.networkTask = dataTransferService.request(with: endpoint) { (result: Result<Data, DataTransferError>) in
            let result = result.mapError { $0 as Error }
            DispatchQueue.main.async { completion(result) }
        }
        return task
    }
    func fetchIngredientImage(with imagePath: String, completion: @escaping (Result<Data, Error>) -> Void) -> Cancellable? {
        let endpoint = ApiRequest.getIngredientsImages(with: imagePath)
        let task = RepositoryTask()
        
        task.networkTask = dataTransferService.request(with: endpoint) { (result: Result<Data, DataTransferError>) in
            let result = result.mapError { $0 as Error }
            DispatchQueue.main.async { completion(result) }
        }
        return task
    }
}
