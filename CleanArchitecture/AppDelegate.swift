//
//  AppDelegate.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 04.10.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let appDIContainer = AppDIContainer()
    var appCoordinator: AppCoordinator?
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController()
        
        window?.rootViewController = navigationController
        appCoordinator = AppCoordinator(navigationController: navigationController, appDIContainer: appDIContainer)
        appCoordinator?.start()
        window?.makeKeyAndVisible()
        return true
    }

}

