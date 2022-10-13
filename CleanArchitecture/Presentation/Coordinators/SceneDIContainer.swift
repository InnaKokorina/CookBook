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
        let imageDataTransferService: DataTransferService
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
    // MARK: - make Reposiories
    
    func makeListReposiories() -> ListReposioryProtocol {
        return ListRepository(dataTransferService: dependencies.dataTransferService, cache: responseCache)
    }
    
    func makeHistoryLisReposiory() -> HistoryListReposioryProtocol {
        return HistoryListRepository(historyStorage: historyStorage)
    }
    func makeImagesRepository() -> ImagesRepositoryPrototcol {
        return ImagesRepository(dataTransferService: dependencies.imageDataTransferService)
    }
    
    
   // MARK: - make MainViewController and ViewModel
    
    func makeMainViewModel(actions: MainViewModelActions) -> MainViewModel {
        return MainViewModel(searchUseCase: makeSearchUseCase(), actions: actions)
    }
 
    func makeMainViewController(actions: MainViewModelActions) -> MainViewController {
        return MainViewController.create(with: makeMainViewModel(actions: actions), imagesRepository: makeImagesRepository())
    }
    
    // MARK: - make ListViewConrtoller

    func makeListViewConroller(actions: MainViewModelActions, viewModel: MainViewModelProtocol, imagesRepository: ImagesRepositoryPrototcol?) -> UIViewController {
        return ListViewController.create(with: viewModel, imagesRepository: imagesRepository)
    }
    // MARK: - makeHistoryQueriesConroller and ViewModel
    
    func makeHisoryListViewModel(didSelect: @escaping (RecipeQuery) -> Void, actions: HistoryViewModelAction) -> HistoryViewModelProtocol{
        return HistoryViewModel(fetchUseCase: makeFetchHisoryUseCase(), didSelect: didSelect, actions: actions )
    }
    
    func makeHistoryViewController(didSelect: @escaping (RecipeQuery) -> Void, actions: HistoryViewModelAction) -> UIViewController {
        return HisoryViewController.create(with: makeHisoryListViewModel(didSelect: didSelect, actions: actions))
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
