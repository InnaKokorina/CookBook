//
//  AppCoordinator.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 05.10.2022.
//

import Foundation
import UIKit

final class AppCoordinator {
    
    private let navigationController: UINavigationController
    private let appDIContainer: AppDIContainer // хранит сцены?
    
    init(navigationController: UINavigationController, appDIContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }
    
    // MARK: - start with mainViewController
    func start() {
        let container = appDIContainer.makeSceneDIContainer()
        let flow = container.makeCoordinator(navigationController: navigationController)
        flow.showMainViewController()
    }
}
