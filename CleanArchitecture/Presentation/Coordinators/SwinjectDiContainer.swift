//
//  DiContainer.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 25.10.2022.
//

import Foundation
import Swinject

class SwinjectDIContainer: Assembly {
    lazy var responseCache: ResponseStorageProtocol = ResponseStorage()
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
            let repository = ListRepository(dataTransferService: self.dataTransferService, cache: self.responseCache)
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
        
        // MARK: - ViewModels
        container.register(MainViewModelProtocol.self) { resolver  in
            let viewModel = MainViewModel(searchUseCase: resolver.resolve(SearchUseCaseProtocol.self)!)
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
        
        // MARK: - ViewControllers
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
    }
}
