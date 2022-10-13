//
//  AppDIContainer.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 05.10.2022.
//

import Foundation

final class AppDIContainer {
    
    // MARK: - network
    lazy var apiDataTransferService: DataTransferService = {
        let config = ApiDataNetworkConfig(baseURL: URL(string: "Network.baseURL".localized())!,
                                          queryParameters: ["Network.ApiKey".localized(): "Network.ApiKeyNumber".localized()])
        let apiDataNetwork = DefaultNetworkService(config: config)
        return DefaultDataTransferService(with: apiDataNetwork)
    }()
    
    lazy var imageDataTransferService: DataTransferService = {
        let config = ApiDataNetworkConfig(baseURL: URL(string: "Network.imageURL".localized())!)
        let imagesDataNetwork = DefaultNetworkService(config: config)
        return DefaultDataTransferService(with: imagesDataNetwork)
    }()
    
    // MARK: - Scenes
    func makeSceneDIContainer() -> SceneDIContainer {
        let dependenciens = SceneDIContainer.Dependencies(dataTransferService: apiDataTransferService, imageDataTransferService: imageDataTransferService)
        return SceneDIContainer(dependencies: dependenciens)
    }
}
