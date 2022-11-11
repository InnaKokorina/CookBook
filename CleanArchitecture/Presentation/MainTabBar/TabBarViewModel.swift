//
//  TabBarViewModel.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 27.10.2022.
//

import Foundation
import UIKit

enum TabBarItemType: Int, CaseIterable {
    case main = 0
    case favorite = 1
}

protocol TabBarViewModelInput {
    func inputData(controllers: [UINavigationController])
}

protocol TabBarViewModelOutput {
    var dataSource: Observable<[UINavigationController]> {get set}
}

protocol TabBarViewModelProtocol: TabBarViewModelInput, TabBarViewModelOutput  { }

// MARK: - TabBarViewModel
final class TabBarViewModel: TabBarViewModelProtocol {
    
    var dataSource: Observable<[UINavigationController]> = Observable(value: [])
    
    func inputData(controllers: [UINavigationController]) {
        dataSource.value = controllers
    }
}
