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
            var orderedSet = [String]()
            
            for query in savedQueries {
                if !orderedSet.contains(query) {
                    orderedSet.append(query)
                }
            }
            let result = orderedSet.filter { $0 != "" }.map { DataRequestDTO(query: $0, offset: 0)}
            print(result)
            return result
        } else {
            return []
        }
    }
    // MARK: - save queries to UserDefaults
    func saveDataToDB(newQuery: DataRequestDTO) {
        var queries = fetchDBData()
        queries.insert(newQuery, at: 0)
        let queriesString = queries.map {$0.query}
        print(queriesString)
        defaults.set(queriesString, forKey: "query")
    }
}
