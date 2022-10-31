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
    
    private let window: UIWindow?
    private let container: Container
    
    init(window: UIWindow?, container: Container) {
        self.window = window
        self.container = container
    }
    
    // MARK: - start with mainViewController
    func start() {
        let coordinator = TabBarCoordinator(window: window, container: container)
        coordinator.start()
    }
}
