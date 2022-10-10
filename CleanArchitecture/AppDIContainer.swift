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
        let config = ApiDataNetworkConfig(baseURL: URL(string: "https://api.spoonacular.com")!,
                                          queryParameters: ["api_key": "67d81a7eb19f4b54ab8b9b5b3dff139c",
                                                            "language": NSLocale.preferredLanguages.first ?? "en"])
        let apiDataNetwork = DefaultNetworkService(config: config)
        return DefaultDataTransferService(with: apiDataNetwork)
    }()
    
    // MARK: - Scenes
    func makeSceneDIContainer() -> SceneDIContainer {
        let dependenciens = SceneDIContainer.Dependencies(dataTransferService: apiDataTransferService)
        return SceneDIContainer(dependencies: dependenciens)
    }
}
