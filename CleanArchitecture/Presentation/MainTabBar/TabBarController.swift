//
//  TabBarController.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 27.10.2022.
//

import UIKit

class TabBarController: UITabBarController {
    
    var viewModel: TabBarViewModelProtocol! {
        didSet {
            bind(to: viewModel)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = .black
        tabBar.backgroundColor = .systemGray5
    }

    func bind(to viewModel: TabBarViewModelProtocol) {
        viewModel.dataSource.subscribe(on: self) { [weak self] _ in
            DispatchQueue.main.async {
                self?.setViewControllers(self?.viewModel.dataSource.value, animated: true)
                self?.viewModel.tabConfigure(tabBarItems: self?.tabBar.items)
           }
        }
    }
}
