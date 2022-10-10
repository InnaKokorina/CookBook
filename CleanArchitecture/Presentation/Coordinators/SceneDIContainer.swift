//
//  SceneDIContainer.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 05.10.2022.
//

import Foundation
import UIKit
// как Assambly в MVP?
final class SceneDIContainer: CoorinatorDependencies {
    
    
    
    
    lazy var responseCache: ResponseStorageProtocol = ResponseStorage()
    lazy var historyStorage: HistoryListStorageProtocol = HistoryListStorage()
    
    struct Dependencies {
        let dataTransferService: DataTransferService
    }
    let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - make UseCases
    
    func makeSearchUseCase() -> SearchUseCaseExecute {
        return SearchUseCase(reposiories: makeListReposiories(), historyReposiory: makeHistoryLisReposiory())
    }
    
    func makeFetchHisoryUseCase(completion: @escaping (Result<[RecipeQuery], Error>) -> Void) -> FetchHistoryUseCase {
        return FetchHistoryUseCase(historyRepository: makeHistoryLisReposiory(), completion: completion)
    }
    // MARK: - make Reposiories
    
    func makeListReposiories() -> ListReposioryProtocol {
        return ListRepository(dataTransferService: dependencies.dataTransferService, cache: responseCache)
    }
    
    func makeHistoryLisReposiory() -> HistoryListReposioryProtocol {
        return HistoryListRepository(historyStorage: historyStorage)
    }
    
   // MARK: - make MainViewController and ViewModel
    
    func makeMainViewModel(actions: MainViewModelActions) -> MainViewModel{
        return MainViewModel(searchUseCase: makeSearchUseCase(), actions: actions)
    }
 
    func makeMainViewController(actions: MainViewModelActions) -> MainViewController {
        return MainViewController.create(with: makeMainViewModel(actions: actions))
    }
    
    // MARK: - make ListViewConrtoller and ViewModel
    
    func makeLisViewModel() {
        
    }
    
    
    func makeListViewConroller(actions: ListViewModelActions) -> UIViewController {
        return ListViewController()
    }
    // MARK: - makeHistoryQueriesConroller and ViewModel
    
    func makeHisoryListViewModel() {
        
    }
    
    func makeHistoryViewController() -> UIViewController {
        return QueryViewController()
    }
    
    
    // MARK: - make DetailViewConroller and ViewModel
    
    func makeDetailViewModel(entity: Recipe) -> DetailViewModel {
        return DetailViewModel(entity: entity)
    }
    
    func makeDetailViewController(entity: Recipe) -> UIViewController {
        return DetailViewController.create(with: makeDetailViewModel(entity: entity))
    }
    
    // MARK: - make Coordinator
    func makeCoordinator(navigationController: UINavigationController) -> Coordinator {
        return Coordinator(navigationController: navigationController, dependencies: self)
    }
}
