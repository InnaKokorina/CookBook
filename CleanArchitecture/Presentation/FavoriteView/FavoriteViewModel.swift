//
//  FavoriteViewModel.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 02.11.2022.
//

import Foundation

struct FavoriteViewModelActions {
    let showDetails: (_ recipeId: Int) -> Void
}

protocol FavoriteViewModelInput {
    func fetchData()
    func handleMoveToTrash(index: Int, completion: @escaping () -> ())
    func didSelectItem(at index: Int) 
}

protocol FavoriteViewModelOutput {
    var favoriteItems: Observable<[FavoriteCellVIewModel]> { get }
    var error: Observable<String> { get }
    var actions: FavoriteViewModelActions? { get set }
}

protocol FavoriteViewModelProtocol: FavoriteViewModelInput, FavoriteViewModelOutput {}

// MARK: - FavoriteViewModel
final class FavoriteViewModel: FavoriteViewModelProtocol {
    
    var favoriteItems: Observable<[FavoriteCellVIewModel]> = Observable(value: [])
    var error: Observable<String> = Observable(value: "")
    var actions: FavoriteViewModelActions?
    var recipe = [FavoriteModel]()
    
    private let favoriteUseCase: FavoriteListUseCaseProtocol

    init(favoriteUseCase: FavoriteListUseCaseProtocol) {
        self.favoriteUseCase = favoriteUseCase
        NotificationCenter.default.addObserver(self, selector: #selector(fetchData), name: NSNotification.Name(rawValue: Constants.messageToFavorite), object: nil)
    }
    // MARK: - output
    func handleMoveToTrash(index: Int, completion: @escaping () -> ()) {
        favoriteUseCase.deleteFromFavorite(deletedRecipe: recipe[index]) { [weak self] error in
            if let error = error {
                self?.error.value = HandleError.coreDataDelete.errorsType
                print(error.localizedDescription)
            }
            self?.recipe.remove(at: index)
            self?.favoriteItems.value.remove(at: index)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.messageToMain), object: nil)
            completion()
        }
    }
    func didSelectItem(at index: Int) {
        actions?.showDetails(favoriteItems.value[index].id)
    }
    
    @objc func fetchData() {
        favoriteUseCase.fetchFavorite { [weak self] result in
            switch result {
            case .success(let recipePage):
                self?.updateFavoriteItems(recipePage)
            case .failure(let error):
                print(error.localizedDescription)
                self?.error.value = HandleError.coreDataFetch.errorsType
            }
        }
    }
    // MARK: - private
    private func updateFavoriteItems(_ recipes: [FavoriteModel]?) {
        guard let recipes = recipes else { return }
        self.recipe = recipes
        self.favoriteItems.value = recipes.map(FavoriteCellVIewModel.init)
    }
    
}
