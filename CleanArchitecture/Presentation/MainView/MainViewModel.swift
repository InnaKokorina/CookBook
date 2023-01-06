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
    let openScanCodeView: () -> Void
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
    func updateFavorite(index: Int)
    func openScanning()
}

protocol MainViewModelOutput {
    var loading: Observable<ListViewModelLoading?> { get }
    var query: Observable<String> { get }
    var error: Observable<String> { get }
    var items: [MainCellViewModel] { get }
    var favoriteIsUpdated:Observable<Int?> {get}
    var allUpdatingRequired: Observable<Void> {get}
    var isEmpty: Bool { get }
    var actions: MainViewModelActions? { get set }
    var pages: [RecipePage] { get set }
    var currentOffset: Int { get }
}

protocol MainViewModelProtocol: MainViewModelInput, MainViewModelOutput {}

// MARK: - MainViewModel
final class MainViewModel: MainViewModelProtocol {

    private let searchUseCase: SearchUseCaseProtocol
    private let favoriteUseCase: FavoriteListUseCaseProtocol
    private var loadTask: Cancellable? { willSet { loadTask?.cancel() } }

    var currentOffset: Int = 0
    var totalCount: Int = 1
    var hasMorePages: Bool { currentOffset < totalCount }
    var nextOffset: Int { hasMorePages ? currentOffset + 10 : currentOffset }
   
    // MARK: - output
    var query: Observable<String> = Observable(value: "")
    let loading: Observable<ListViewModelLoading?> = Observable(value: .none)
    var error: Observable<String> = Observable(value: "")
    var items: [MainCellViewModel] = []
    var favoriteIsUpdated: Observable<Int?> = Observable(value: nil)
    var allUpdatingRequired: Observable<Void> = Observable(value: ())
    var isEmpty: Bool { return items.isEmpty }
    var actions: MainViewModelActions?
    var pages: [RecipePage] = []
    
    init(searchUseCase: SearchUseCaseProtocol, favoriteUseCase: FavoriteListUseCaseProtocol) {
        self.searchUseCase = searchUseCase
        self.favoriteUseCase = favoriteUseCase
        NotificationCenter.default.addObserver(self, selector: #selector(updateMain), name: NSNotification.Name(rawValue: Constants.messageToMain), object: nil)
    }
    
    // MARK: - private
    private func load(request: RecipeQuery, loading: ListViewModelLoading, completion: @escaping () -> ()) {
        self.loading.value = loading
        query.value = request.query
        loadTask = searchUseCase.execute(request: .init(query: request), offset: nextOffset) { [weak self] result in
            switch result {
            case .success(let results):
                self?.transferToList(results) {
                    
                    if let recipes = self?.pages.recipes {
                        self?.favoriteUseCase.checkFavoritesOnMain(recipes: recipes) { recipes in
                            DispatchQueue.main.async {
                                self?.loading.value = .none
                                self?.allUpdatingRequired.value = ()
                                self?.items = recipes.map(MainCellViewModel.init)

                                completion()
                            }
                        }
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
                self?.error.value = error.isInternetConnectionError ? HandleError.network.errorsType : HandleError.server.errorsType
            }
        }
    }
    
    private func transferToList(_ recipePage: RecipePage, completion: () -> ()) {
        guard let offset = recipePage.offset,
              let totalResult = recipePage.totalResults else { return }
        currentOffset = offset
        totalCount = totalResult
        pages = pages.filter { $0.offset != recipePage.offset } + [recipePage]
        completion()
    }
   
    
    private func update(query: RecipeQuery) {
        self.resetPages()
        load(request: query, loading: .fullScreen) {
            self.actions?.showResultsList(self)
        }
    }

    private func sendMessage() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.messageToFavorite), object: nil)
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
        actions?.showDetails(items[index].id)
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
        items.removeAll()
        allUpdatingRequired.value = ()
    }
    
    func openScanning() {
        actions?.openScanCodeView()
    }
    
    func updateFavorite(index: Int) {
        items[index].isLiked?.toggle()
        favoriteIsUpdated.value = index
        let id = items[index].id
        for item in items {
            if item.id == id {
                guard let isLiked = item.isLiked else { return }
                if isLiked == true {
                    favoriteUseCase.saveToFavorite(savedRecipe: pages.recipes[index]) { [weak self] error in
                        if let error = error {
                            self?.error.value = HandleError.coreDataSave.errorsType
                            print(error.localizedDescription)
                        } else {
                            self?.sendMessage()
                        }
                    }
                } else {
                    let recipe = pages.recipes[index]
                    let favorite = FavoriteModel(id: recipe.id, title: recipe.title, imagePath: recipe.imagePath)
                    favoriteUseCase.deleteFromFavorite(deletedRecipe: favorite) { [weak self] error in
                        if let error = error {
                            self?.error.value = HandleError.coreDataDelete.errorsType
                            print(error.localizedDescription)
                        } else {
                        self?.sendMessage()
                        }
                    }
                }
            }
        }
    }
    
    @objc func updateMain() {
        update(query: RecipeQuery(query: query.value, offset: nextOffset))
    }
}
// MARK: - extension

private extension Array where Element == RecipePage {
    var recipes: [Recipe] { flatMap { $0.recipes} }
}
