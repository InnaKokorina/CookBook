//
//  DiContainer.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 25.10.2022.
//

import Foundation
import Swinject

class SwinjectDIContainer: Assembly {
    lazy var responseCache: RecipesListDataBaseStorageProtocol = RecipesListDataBaseStorage()
    lazy var historyStorage: HistoryListStorageProtocol = HistoryListStorage()
    // MARK: - network
    lazy var dataTransferService: DataTransferService = {
        let config = ApiDataNetworkConfig(baseURL: URL(string: Constants.baseURL ?? "")!,
                                          queryParameters: [Constants.apiKey ?? "": Constants.apiKeyNumber ?? ""])
        let apiDataNetwork = DefaultNetworkService(config: config)
        return DefaultDataTransferService(with: apiDataNetwork)
    }()
    
    func assemble(container: Container) {
        
        // MARK: - Repositories
        container.register(ListReposioryProtocol.self) { _  in
            let repository = ListRepository(dataTransferService: self.dataTransferService)
            return repository
        }
        container.register(HistoryListReposioryProtocol.self) { resolver in
            let repository = HistoryListRepository(historyStorage: self.historyStorage)
            return repository
        }
        container.register(FetchDetailRepositoryProtocol.self) { resolver in
            let repository = DetailRepository(dataTransferService: self.dataTransferService)
            return repository
        }
        container.register(FavoriteListRepositoryProtocol.self) { resolver in
            let repository = FavoriteListRepository(cache: self.responseCache)
            return repository
        }
        
        // MARK: - useCase
        container.register(SearchUseCaseProtocol.self) { resolver  in
            let useCase = SearchUseCase(reposiories: resolver.resolve(ListReposioryProtocol.self)!, historyReposiory: resolver.resolve(HistoryListReposioryProtocol.self)!)
            return useCase
        }
        container.register(FetchHisoryUseCaseProtocol.self) { resolver in
            let useCase = FetchHistoryUseCase(historyRepository: resolver.resolve(HistoryListReposioryProtocol.self)!)
            return useCase
        }
        container.register(FetchDetailUseCaseProtocol.self) { resolver in
            let useCase = FetchDetailUseCase(fetchDetailRepository: resolver.resolve(FetchDetailRepositoryProtocol.self)!)
            return useCase
        }
        container.register(FavoriteListUseCaseProtocol.self) { resolver in
            let useCase = FavoriteListUseCase(repository: resolver.resolve(FavoriteListRepositoryProtocol.self)!)
                return useCase
        }.inObjectScope(.container)
        
        // MARK: - ViewModels
        container.register(TabBarViewModelProtocol.self) { _  in
            let viewModel = TabBarViewModel()
            return viewModel
        }
        container.register(MainViewModelProtocol.self) { resolver  in
            let viewModel = MainViewModel(searchUseCase: resolver.resolve(SearchUseCaseProtocol.self)!, favoriteUseCase: resolver.resolve(FavoriteListUseCaseProtocol.self)!)
            return viewModel
        }.inObjectScope(.container)
        
        container.register(DetailViewModelProtocol.self) { resolver  in
            let viewModel = DetailViewModel(detailUseCase: resolver.resolve(FetchDetailUseCaseProtocol.self)!)
            return viewModel
        } 
        container.register(HistoryViewModelProtocol.self) {  resolver  in
            let viewModel = HistoryViewModel(fetchUseCase: resolver.resolve(FetchHisoryUseCaseProtocol.self)!)
            return viewModel
        }
        container.register(FavoriteViewModelProtocol.self) {  resolver  in
            let viewModel = FavoriteViewModel(favoriteUseCase: resolver.resolve(FavoriteListUseCaseProtocol.self)!)
            return viewModel
        }
        
        // MARK: - ViewControllers
        container.register(TabBarController.self) { resolver in
            let tabBarVC = TabBarController()
            tabBarVC.viewModel = resolver.resolve(TabBarViewModelProtocol.self)!
            return tabBarVC
        }
        container.register(MainViewController.self) { resolver in
            let vc = MainViewController()
            vc.viewModel = resolver.resolve(MainViewModelProtocol.self)!
        return vc
        }
        container.register(ListViewController.self) { resolver in
            let vc = ListViewController()
            vc.viewModel = resolver.resolve(MainViewModelProtocol.self)
        return vc
        }
        container.register(HistoryViewController.self) { resolver in
            let vc = HistoryViewController()
            vc.viewModel = resolver.resolve(HistoryViewModelProtocol.self)
        return vc
        }
        container.register(DetailViewController.self) { resolver in
            let vc = DetailViewController()
            vc.viewModel = resolver.resolve(DetailViewModelProtocol.self)
        return vc
        }
        container.register(FavoriteViewController.self) { resolver in
            let vc = FavoriteViewController()
            vc.viewModel = resolver.resolve(FavoriteViewModelProtocol.self)
        return vc
        }
    }
}
