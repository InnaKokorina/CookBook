//
//  TabBarCoordinator.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 27.10.2022.
//

import Foundation
import Swinject

final class TabBarCoordinator {
    private weak var window: UIWindow?
    private let container: Container
    
    init(window: UIWindow?, container: Container) {
       self.window = window
        self.container = container
    }
    
    func start() {
        guard let tabBarVC = container.resolve(TabBarController.self),
              let window = window else { return }
        let flowCoordinator = SceneCoordinator(container: container)

        guard let mainNavVC = flowCoordinator.showMainViewController(),
              let favoriteNavVC = flowCoordinator.showFavoriteViewController() else { return }
        
        tabBarVC.viewModel.inputData(controllers: [mainNavVC, favoriteNavVC])
        window.rootViewController = tabBarVC
    }
}
