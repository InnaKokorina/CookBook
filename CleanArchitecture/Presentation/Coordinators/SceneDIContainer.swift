//
//  SceneDIContainer.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 05.10.2022.
//

import Foundation
import UIKit

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
    
    private func makeFetchHisoryUseCase() -> FetchHisoryUseCaseExecute {
        return FetchHistoryUseCase(historyRepository: makeHistoryLisReposiory())
    }
    
    func makeDetailUseCase() -> FetchDetailUseCaseProtocol {
        return FetchDetailUseCase(fetchDetailRepository: makeDetailRepository())
    }
    // MARK: - make Reposiories
    
    func makeListReposiories() -> ListReposioryProtocol {
        return ListRepository(dataTransferService: dependencies.dataTransferService, cache: responseCache)
    }
    
    func makeHistoryLisReposiory() -> HistoryListReposioryProtocol {
        return HistoryListRepository(historyStorage: historyStorage)
    }
    
    func makeDetailRepository() -> FetchDetailRepositoryProtocol {
        return DetailRepository(dataTransferService: dependencies.dataTransferService)
    }
    
   // MARK: - make MainViewController and ViewModel
    
    func makeMainViewModel(actions: MainViewModelActions) -> MainViewModelProtocol {
        return MainViewModel(searchUseCase: makeSearchUseCase(), actions: actions)
    }
 
    func makeMainViewController(actions: MainViewModelActions) -> MainViewController {
        return MainViewController.create(with: makeMainViewModel(actions: actions))
    }
    
    // MARK: - make ListViewConrtoller

    func makeListViewConroller(actions: MainViewModelActions, viewModel: MainViewModelProtocol) -> UIViewController {
        return ListViewController.create(with: viewModel)
    }
    // MARK: - makeHistoryQueriesConroller and ViewModel
    
    func makeHisoryListViewModel(didSelect: @escaping (RecipeQuery) -> Void, actions: HistoryViewModelAction) -> HistoryViewModelProtocol{
        return HistoryViewModel(fetchUseCase: makeFetchHisoryUseCase(), didSelect: didSelect, actions: actions )
    }
    
    func makeHistoryViewController(didSelect: @escaping (RecipeQuery) -> Void, actions: HistoryViewModelAction) -> UIViewController {
        return HisoryViewController.create(with: makeHisoryListViewModel(didSelect: didSelect, actions: actions))
    }
    
    
    // MARK: - make DetailViewConroller and ViewModel
    
    func makeDetailViewModel(recipeId: Int) -> DetailViewModelProtocol {
        return DetailViewModel(detailUseCase: makeDetailUseCase(), recipeId: recipeId)
    }
    
    func makeDetailViewController(recipeId: Int) -> UIViewController {
        return DetailViewController.create(with: makeDetailViewModel(recipeId: recipeId))
    }
    
    // MARK: - make Coordinator
    func makeCoordinator(navigationController: UINavigationController) -> Coordinator {
        return Coordinator(navigationController: navigationController, dependencies: self)
    }
}
