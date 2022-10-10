//
//  MainViewModel.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 05.10.2022.
//

import Foundation

struct MainViewModelActions {
    let showResultsList: () -> Void
    let showHisoryList: () -> Void
    let closeHisoryList: () -> Void
    let closeListViewConroller: () -> ()
}
protocol MainViewModelInput {
    func showHistoryQuerieslist()
    func closeQueriesSuggestions()
}

protocol MainViewModelOutput {
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
    
    // MARK: - private
    private func update(request: RecipeQuery) {
        let loadTask = searchUseCase.execute(request: .init(query: request)) { result in
            switch result {
            case .success(let results):
                print("results = \(results)")
                print("result = \(result)")
            case .failure(let error):
                print(error)
            }
        }
    }
      
    // MARK: - input
    func showResultsList(query: String) {
        update(request: RecipeQuery(query: query))
        actions?.showResultsList()
    }

    func showHistoryQuerieslist() {
        actions?.showHisoryList()
    }
    func closeQueriesSuggestions() {
        actions?.closeHisoryList()
    }
}
