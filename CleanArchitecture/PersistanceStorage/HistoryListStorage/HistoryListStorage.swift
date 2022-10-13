//
//  HistoryListStorage.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 06.10.2022.
//

import Foundation

final class HistoryListStorage: HistoryListStorageProtocol {
    let dataBaseStorage: DataBaseStorage
    
    init(dataBaseStorage: DataBaseStorage = DataBaseStorage.shared) {
        self.dataBaseStorage = dataBaseStorage
    }
    
    func fetchHistoryQueries(completion: @escaping (Result<[DataRequestDTO], Error>) -> Void) {
        let data = dataBaseStorage.fetchDBData()
        
        completion(.success(data))
    }
    
    func saveHistoryQuery(query: DataRequestDTO) {
        dataBaseStorage.saveDataToDB(newQuery: query)
    }
}
