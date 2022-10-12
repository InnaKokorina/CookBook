//
//  ResponseStorage.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 06.10.2022.
//

import Foundation

final class ResponseStorage: ResponseStorageProtocol {
   
    let dataBaseStorage: DataBaseStorage
    
    init(dataBaseStorage: DataBaseStorage = DataBaseStorage.shared) {
        self.dataBaseStorage = dataBaseStorage
    }

    
    func getResponse(for request: DataRequestDTO, completion: @escaping (Result<[DataResponseDTO]?, Error>) -> Void) {
        // fetch Request from DB
    }
    
    func save(response: [DataResponseDTO], for requestDto: DataRequestDTO) {
        // save to DB
    }
}
