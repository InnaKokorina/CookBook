//
//  AppDelegate.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 04.10.2022.
//

import UIKit
import Swinject
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private var appCoordinator: AppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)  
        let appDIContainer = AppDIContainer.assembler.resolver as! Container
        appCoordinator = AppCoordinator(window: window, container: appDIContainer)
        appCoordinator?.start()
        window?.makeKeyAndVisible()
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print("CoreData - \(urls[urls.count-1] as URL)")
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        CoreDataStorage.shared.saveContext()
    }
}

