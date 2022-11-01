//
//  TabBarViewModel.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 27.10.2022.
//

import Foundation
import UIKit

protocol TabBarViewModelInput {
    func tabConfigure(tabBarItems: [UITabBarItem]?)
    func inputData(controllers: [UINavigationController])
}

protocol TabBarViewModelOutput {
    var dataSource: Observable<[UINavigationController]> {get set}
}

protocol TabBarViewModelProtocol: TabBarViewModelInput, TabBarViewModelOutput  { }

// MARK: - TabBarViewModel
final class TabBarViewModel: TabBarViewModelProtocol {
    
    var dataSource: Observable<[UINavigationController]> = Observable(value: [])
    
    func tabConfigure(tabBarItems: [UITabBarItem]?) {
        guard let items = tabBarItems else { return }
        let images = [Constants.tabBarFirstImage, Constants.tabBarSecondImage]
        let title = [Constants.tabBarFirstTitle, Constants.tabBarSecondTitle]
        for index in 0..<items.count {
            items[index].image = UIImage(systemName: images[index])
            items[index].title = title[index]
        }
    }
    
    func inputData(controllers: [UINavigationController]) {
        dataSource.value = controllers
    }
}
