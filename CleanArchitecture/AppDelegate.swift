//
//  AppDelegate.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 04.10.2022.
//

import UIKit
import Swinject

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private var appCoordinator: AppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController()
        
        window?.rootViewController = navigationController
        
        let appDIContainer = AppDIContainer.assembler.resolver as! Container
        appCoordinator = AppCoordinator(navigationController: navigationController, container: appDIContainer)
        appCoordinator?.start()
        window?.makeKeyAndVisible()
        return true
    }

}

