//
//  DataBaseStorage.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 06.10.2022.
//

import Foundation

final class DataBaseStorage {
    static let shared = DataBaseStorage()
    private let defaults = UserDefaults.standard
    
    // MARK: - fetch queries from UserDefaults
    func fetchDBData()  -> [DataRequestDTO] {
        if let savedQueries = defaults.stringArray(forKey: "query") {
            return savedQueries.map { DataRequestDTO(query: $0, offset: 0)}
        } else {
            return []
        }
    }
    // MARK: - save queries to UserDefaults
    func saveDataToDB(newQuery: DataRequestDTO) {
        var queries = fetchDBData()
        queries.append(newQuery)
        let queriesString = queries.map {$0.query}
        defaults.set(queriesString, forKey: "query")
    }
}
