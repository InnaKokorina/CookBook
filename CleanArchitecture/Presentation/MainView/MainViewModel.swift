//
//  MainViewModel.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 05.10.2022.
//

import Foundation

struct MainViewModelActions {
    let showResultsList: (_ viewModel: MainViewModelProtocol, _ imagesRepository: ImagesRepositoryPrototcol?) -> Void
    let showHistoryList: (_ didSelect: @escaping (RecipeQuery) -> Void) -> Void
    let closeHistoryList: () -> Void
    let closeListViewConroller: () -> ()
    let showDetails: (Recipe) -> Void
}

enum MoviesListViewModelLoading {
    case fullScreen
    case nextPage
}

protocol MainViewModelInput {
    func showHistoryQuerieslist(with imagesRepository: ImagesRepositoryPrototcol?)
    func closeQueriesSuggestions()
    func didSelectItem(at index: Int)
    func didLoadNextPage()
    func didCancelSearch()
}

protocol MainViewModelOutput {
    var loading: Observable<MoviesListViewModelLoading?> { get }
    var entity: [Recipe] { get }
    var query: Observable<String> { get }
    var error: Observable<String> { get }
    var items: Observable<[MainCellViewModel]> { get }
    var isEmpty: Bool { get }
    var errorTitle: String { get }
}

protocol MainViewModelProtocol: MainViewModelInput, MainViewModelOutput {}

// MARK: - MainViewModel
final class MainViewModel: MainViewModelProtocol {
    
    private let actions: MainViewModelActions?
    private let searchUseCase: SearchUseCaseExecute
    private var imageRepository: ImagesRepositoryPrototcol?
    private var pages: [RecipePage] = []
    private var moviesLoadTask: Cancellable? { willSet { moviesLoadTask?.cancel() } }
    
    var currentOffset: Int = 0
    var totalCount: Int = 1
    var hasMorePages: Bool { currentOffset < totalCount }
    var nextOffset: Int { hasMorePages ? currentOffset + 10 : currentOffset }
   
    init(searchUseCase: SearchUseCaseExecute, actions: MainViewModelActions) {
        self.actions = actions
        self.searchUseCase = searchUseCase
    }
   
    // MARK: - output
    var query: Observable<String> = Observable(value: "")
    let loading: Observable<MoviesListViewModelLoading?> = Observable(value: .none)
    var error: Observable<String> = Observable(value: "")
    var items: Observable<[MainCellViewModel]> = Observable(value: [])
    var entity = [Recipe]()
    var isEmpty: Bool { return items.value.isEmpty }
    let errorTitle = "Error".localized()
    
    // MARK: - private
    private func load(request: RecipeQuery, loading: MoviesListViewModelLoading, completion: @escaping () -> ()) {
        self.loading.value = loading
        query.value = request.query
        moviesLoadTask = searchUseCase.execute(request: .init(query: request), offset: nextOffset) { [weak self] result in
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
            self.actions?.showResultsList(self, self.imageRepository)
        }
    }
    
    private func handle(error: Error) {
        self.error.value = error.isInternetConnectionError ? "No internet connection".localized() : "Failed loading".localized()
    }
    
    func resetPages() {
        currentOffset = 0
        totalCount = 1
        pages.removeAll()
        items.value.removeAll()
    }
    
    // MARK: - input
    func showResultsList(query: String, imageRepository: ImagesRepositoryPrototcol?) {
        guard !query.isEmpty else { return }
        self.imageRepository = imageRepository
        update(query: RecipeQuery(query: query, offset: nextOffset))
    }
    func closeResultsList() {
        actions?.closeListViewConroller()
    }
    func showHistoryQuerieslist(with imagesRepository: ImagesRepositoryPrototcol?) {
        self.imageRepository = imagesRepository
        actions?.showHistoryList(update(query: ))
    }
    func closeQueriesSuggestions() {
        actions?.closeHistoryList()
    }
    func didSelectItem(at index: Int) {
        actions?.showDetails(entity[index])
    }
    func didLoadNextPage() {
        guard hasMorePages else { return }
        load(request: .init(query: query.value, offset: nextOffset), loading: .nextPage) {
        }
    }
    func didCancelSearch() {
        moviesLoadTask?.cancel()
    }
}
// MARK: - extension

private extension Array where Element == RecipePage {
    var recipes: [Recipe] { flatMap { $0.recipes} }
}
