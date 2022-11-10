//
//  RecipesListDataBaseStorage.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 03.11.2022.
//

import Foundation
import CoreData
import Accessibility
protocol RecipesListDataBaseStorageProtocol {
    func fetchResponse(completion: @escaping (Result<[DataBaseResponseDTO]?, Error>) -> Void)
    func save(selectedData: DataBaseResponseDTO, completion: @escaping (Error?) -> ())
    func delete(selectedData: DataBaseResponseDTO, completion: @escaping (Error?) -> ())
}

final class RecipesListDataBaseStorage {

    private let coreDataStorage: CoreDataStorage

    init(coreDataStorage: CoreDataStorage = CoreDataStorage.shared) {
        self.coreDataStorage = coreDataStorage
    }

    // MARK: - Private

    private func fetchRequest() -> NSFetchRequest<RecipesCoreDataModel> {
        let request: NSFetchRequest = RecipesCoreDataModel.fetchRequest()
        return request
    }
}

extension RecipesListDataBaseStorage: RecipesListDataBaseStorageProtocol {

    func fetchResponse(completion: @escaping (Result<[DataBaseResponseDTO]?, Error>) -> Void) {
        coreDataStorage.performBackgroundTask { context in
            do {
                let fetchRequest = self.fetchRequest()
                let requestEntity = try context.fetch(fetchRequest)
                completion(.success(requestEntity.map { $0.toDTO() }))
            } catch {
                completion(.failure(CoreDataStorageError.readError(error)))
            }
        }
    }

    func save(selectedData: DataBaseResponseDTO, completion: @escaping (Error?) -> ()) {
        coreDataStorage.performBackgroundTask { context in
            do {
                let requestEntity: RecipesCoreDataModel = selectedData.toCoreDataEntity(in: context)
                try context.save()
                completion(nil)
            } catch {
                // TODO: - Log to Crashlytics
                debugPrint("CoreDataMoviesResponseStorage Unresolved error \(error), \((error as NSError).userInfo)")
                completion(CoreDataStorageError.readError(error))
            }
        }
    }
    
    func delete(selectedData: DataBaseResponseDTO, completion: @escaping (Error?) -> ()) {
        coreDataStorage.performBackgroundTask { context in
            do {
            let coreDataobject = selectedData.toCoreDataEntity(in: context)
                let fetchRequest = self.fetchRequest()
                let requestEntity = try context.fetch(fetchRequest)
                for entity in requestEntity {
                    if entity.id == selectedData.id {
                        context.delete(entity)
                        try context.save()
                    }
                }
                completion(nil)
            } catch {
                // TODO: - Log to Crashlytics
                debugPrint("CoreDataMoviesResponseStorage Unresolved error \(error), \((error as NSError).userInfo)")
                completion(CoreDataStorageError.readError(error))
            }
        }
    }
}
