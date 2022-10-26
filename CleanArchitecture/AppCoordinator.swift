//
//  AppCoordinator.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 05.10.2022.
//

import Foundation
import UIKit
import Swinject

final class AppCoordinator {
    
    private let navigationController: UINavigationController
    private let container: Container
    
    init(navigationController: UINavigationController, container: Container) {
        self.navigationController = navigationController
        self.container = container
    }
    
    // MARK: - start with mainViewController
    func start() {
        let coordinator = SceneCoordinator(navigationController: navigationController, container: container)
        coordinator.showMainViewController()
    }
}
