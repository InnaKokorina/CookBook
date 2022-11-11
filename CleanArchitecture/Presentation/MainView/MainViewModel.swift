//
//  MainViewModel.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 05.10.2022.
//

import Foundation

struct MainViewModelActions {
    let showResultsList: (_ viewModel: MainViewModelProtocol) -> Void
    let showHistoryList: (_ didSelect: @escaping (RecipeQuery) -> Void) -> Void
    let closeHistoryList: () -> Void
    let showDetails: (_ recipeId: Int) -> Void
}

enum ListViewModelLoading {
    case fullScreen
    case nextPage
}

protocol MainViewModelInput {
    func showResultsList(query: String)
    func showHistoryQuerieslist()
    func closeQueriesSuggestions()
    func didSelectItem(at index: Int)
    func didLoadNextPage()
    func didCancelSearch()
    func resetPages()
}

protocol MainViewModelOutput {
    var loading: Observable<ListViewModelLoading?> { get }
    var entity: [Recipe] { get }
    var query: Observable<String> { get }
    var error: Observable<String> { get }
    var items: Observable<[MainCellViewModel]> { get }
    var isEmpty: Bool { get }
    var errorTitle: String { get }
    var actions: MainViewModelActions? { get set }
}

protocol MainViewModelProtocol: MainViewModelInput, MainViewModelOutput {}

// MARK: - MainViewModel
final class MainViewModel: MainViewModelProtocol {

    private let searchUseCase: SearchUseCaseProtocol
    private var pages: [RecipePage] = []
    private var loadTask: Cancellable? { willSet { loadTask?.cancel() } }

    var currentOffset: Int = 0
    var totalCount: Int = 1
    var hasMorePages: Bool { currentOffset < totalCount }
    var nextOffset: Int { hasMorePages ? currentOffset + 10 : currentOffset }
   
    init(searchUseCase: SearchUseCaseProtocol) {
        self.searchUseCase = searchUseCase
    }
   
    // MARK: - output
    var query: Observable<String> = Observable(value: "")
    let loading: Observable<ListViewModelLoading?> = Observable(value: .none)
    var error: Observable<String> = Observable(value: "")
    var items: Observable<[MainCellViewModel]> = Observable(value: [])
    var entity = [Recipe]()
    var isEmpty: Bool { return items.value.isEmpty }
    let errorTitle = "Error".localized()
    var actions: MainViewModelActions?
    
    // MARK: - private
    private func load(request: RecipeQuery, loading: ListViewModelLoading, completion: @escaping () -> ()) {
        self.loading.value = loading
        query.value = request.query
        loadTask = searchUseCase.execute(request: .init(query: request), offset: nextOffset) { [weak self] result in
            switch result {
            case .success(let results):
                self?.transferToList(results)
                completion()
            case .failure(let error):
                self?.handle(error: error)
            }
            self?.loading.value = .none
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
        items.value = pages.recipes.map(MainCellViewModel.init)
    }
    
    private func update(query: RecipeQuery) {
        resetPages()
        load(request: query, loading: .fullScreen) {
           
        }
        self.actions?.showResultsList(self)
    }
    
    private func handle(error: Error) {
        self.error.value = error.isInternetConnectionError ? "No internet connection".localized() : "Failed loading".localized()
    }

    // MARK: - input
    func showResultsList(query: String) {
        guard !query.isEmpty else { return }
        update(query: RecipeQuery(query: query, offset: nextOffset))
    }

    func showHistoryQuerieslist() {
        resetPages()
        actions?.showHistoryList(update(query: ))
    }
    
    func closeQueriesSuggestions() {
        actions?.closeHistoryList()
    }
    
    func didSelectItem(at index: Int) {
        actions?.showDetails(items.value[index].id)  
    }
    
    func didLoadNextPage() {
        guard hasMorePages else { return }
        load(request: .init(query: query.value, offset: nextOffset), loading: .nextPage) {
        }
    }
    
    func didCancelSearch() {
        loadTask?.cancel()
    }
    
    func resetPages() {
        currentOffset = 0
        totalCount = 1
        pages.removeAll()
        items.value.removeAll()
    }
}
// MARK: - extension

private extension Array where Element == RecipePage {
    var recipes: [Recipe] { flatMap { $0.recipes} }
}
