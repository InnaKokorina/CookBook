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
    
    func fetchHistoryQueries(completion: @escaping (Result<[RecipeQuery], Error>) -> Void) {
        // fetch Request from DB
        dataBaseStorage.fetchDBData()
    }
    
    func saveHistoryQuery(query: RecipeQuery, completion: @escaping (Result<RecipeQuery, Error>) -> Void) {
        // save to DB
        dataBaseStorage.saveDataToDB()
    }
}
