//
//  FavoriteListUseCase.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 07.11.2022.
//

import Foundation
protocol FavoriteListUseCaseProtocol {  
    func fetchFavorite(completion: @escaping (Result<[FavoriteModel]?, Error>) -> Void)
    func saveToFavorite(savedRecipe: Recipe, completion: @escaping (Error?) -> ())
    func deleteFromFavorite(deletedRecipe: FavoriteModel, completion: @escaping (Error?) -> ())
    func checkFavoritesOnMain(recipes: [Recipe], completion: @escaping ([Recipe]) -> ())
}

final class FavoriteListUseCase: FavoriteListUseCaseProtocol {
    private let repository: FavoriteListRepositoryProtocol
    
    init(repository: FavoriteListRepositoryProtocol) {
        self.repository = repository
    }
    
    func fetchFavorite(completion: @escaping (Result<[FavoriteModel]?, Error>) -> Void){
        repository.fetchFavoriteFromDB(completion: completion)
    }
    
    func saveToFavorite(savedRecipe: Recipe, completion: @escaping (Error?) -> ()) {
        let favorite = FavoriteModel(id: savedRecipe.id, title: savedRecipe.title, imagePath: savedRecipe.imagePath)
        repository.saveToFavoriteDB(selectedData: favorite, completion: completion)
    }
    
    func deleteFromFavorite(deletedRecipe: FavoriteModel, completion: @escaping (Error?) -> ()) {
        repository.deleteFromFavoriteDB(selectedData: deletedRecipe, completion: completion)
    }
    
    func checkFavoritesOnMain(recipes: [Recipe], completion: @escaping ([Recipe]) -> ()) {
        var localRecipes = recipes
        fetchFavorite { result in
            switch result {
            case .success(let favorite) :
                if let favorite = favorite {
                    for (index, each) in localRecipes.enumerated() {
                        if favorite.map({$0.id}).contains(each.id) {
                            localRecipes[index].isliked = true
                        }
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
            completion(localRecipes)
        }
    }
}
