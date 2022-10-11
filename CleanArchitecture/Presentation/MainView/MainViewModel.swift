//
//  MainViewModel.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 05.10.2022.
//

import Foundation

struct MainViewModelActions {
    let showResultsList: (_ entity: [Recipe], _ imagesRepository: ImagesRepositoryPrototcol?) -> Void
    let showHisoryList: () -> Void
    let closeHisoryList: () -> Void
    let closeListViewConroller: () -> ()
}
protocol MainViewModelInput {
    func showHistoryQuerieslist()
    func closeQueriesSuggestions()
}

protocol MainViewModelOutput {
    var entity: [Recipe] { get }
    var query: Observable<String> { get }
    var error: Observable<String> { get }
}

protocol MainViewModelProtocol: MainViewModelInput, MainViewModelOutput {}

// MARK: - MainViewModel
final class MainViewModel: MainViewModelProtocol {
    private let actions: MainViewModelActions?
    private let searchUseCase: SearchUseCaseExecute
    
    init(searchUseCase: SearchUseCaseExecute, actions: MainViewModelActions) {
        self.actions = actions
        self.searchUseCase = searchUseCase
    }
   
    // MARK: - output
    var query: Observable<String> = Observable(value: "")
    var error: Observable<String> = Observable(value: "")
    var entity = [Recipe]()
    
    // MARK: - private
    private func update(request: RecipeQuery, completion: @escaping () -> ()) {
        
        _ = searchUseCase.execute(request: .init(query: request)) { [weak self] result in
            switch result {
            case .success(let results):
                self?.transferToList(results)
                completion()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func transferToList(_ results: RecipePage) {
        entity = results.recipes
    }
      
    // MARK: - input
    func showResultsList(query: String, imageRepository: ImagesRepositoryPrototcol?) {
        update(request: RecipeQuery(query: query)) {
            self.actions?.showResultsList(self.entity, imageRepository)
        }
    }

    func closeResultsList() {
        actions?.closeListViewConroller()
    }
    
    func showHistoryQuerieslist() {
        actions?.showHisoryList()
    }
    func closeQueriesSuggestions() {
        actions?.closeHisoryList()
    }
}
