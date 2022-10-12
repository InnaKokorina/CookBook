//
//  MainViewModel.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 05.10.2022.
//

import Foundation

struct MainViewModelActions {
    let showResultsList: (_ viewModel: MainViewModelProtocol, _ imagesRepository: ImagesRepositoryPrototcol?) -> Void
    let showHisoryList: () -> Void
    let closeHisoryList: () -> Void
    let closeListViewConroller: () -> ()
    let showDetails: (Recipe) -> Void
}
protocol MainViewModelInput {
    func showHistoryQuerieslist()
    func closeQueriesSuggestions()
    func didSelectItem(at index: Int)
    func didLoadNextPage()
}

protocol MainViewModelOutput {
    var entity: [Recipe] { get }
    var query: Observable<String> { get }
    var error: Observable<String> { get }
    var items: Observable<[MainCellViewModel]> { get }
}

protocol MainViewModelProtocol: MainViewModelInput, MainViewModelOutput {}

// MARK: - MainViewModel
final class MainViewModel: MainViewModelProtocol {
    
    private let actions: MainViewModelActions?
    private let searchUseCase: SearchUseCaseExecute
    
    var currentOffset: Int = 0
    var totalCount: Int = 1
    var hasMorePages: Bool { currentOffset < totalCount }
    var nextOffset: Int { hasMorePages ? currentOffset + 50 : currentOffset }

    private var pages: [RecipePage] = []
    
    init(searchUseCase: SearchUseCaseExecute, actions: MainViewModelActions) {
        self.actions = actions
        self.searchUseCase = searchUseCase
    }
   
    // MARK: - output
    var query: Observable<String> = Observable(value: "")
    var error: Observable<String> = Observable(value: "")
    var items: Observable<[MainCellViewModel]> = Observable(value: [])
    var entity = [Recipe]()
    
    // MARK: - private
    private func update(request: RecipeQuery, completion: @escaping () -> ()) {
        _ = searchUseCase.execute(request: .init(query: request), offset: nextOffset) { [weak self] result in
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
        appendNewOffset(results)
    }
    private func appendNewOffset(_ recipePage: RecipePage) {
        
        currentOffset = recipePage.offset
        totalCount = recipePage.totalResults

        pages = pages
            .filter { $0.offset != recipePage.offset }
            + [recipePage]
print(pages)
        items.value = pages.recipes.map(MainCellViewModel.init)
        print(items.value.count)
    }
    private func resetPages() {
        currentOffset = 0
        totalCount = 1
        pages.removeAll()
        items.value.removeAll()
    }
      
    // MARK: - input
    func showResultsList(query: String, imageRepository: ImagesRepositoryPrototcol?) {
        resetPages()
        update(request: RecipeQuery(query: query, offset: nextOffset)) {
            self.actions?.showResultsList(self, imageRepository)
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
    func didSelectItem(at index: Int) {
        actions?.showDetails(entity[index])
    }
    func didLoadNextPage() {
        guard hasMorePages else { return }
        print(nextOffset)
        update(request: .init(query: query.value, offset: nextOffset)) {
          // nothing
        }
    }
}
// MARK: - Private

private extension Array where Element == RecipePage {
    var recipes: [Recipe] { flatMap { $0.recipes} }
}
