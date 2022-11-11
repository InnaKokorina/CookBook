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
                TabBarItemType.allCases.forEach { type in
                    let item = self?.tabBar.items?[type.rawValue]
                    item?.image = type.getImage()
                    item?.title = type.getTitle()
                }
           }
        }
    }
}
// MARK: - TabBarItemType
extension TabBarItemType {
    func getImage() -> UIImage {
        let images = [Constants.tabBarFirstImage, Constants.tabBarSecondImage]
        return UIImage(systemName: images[self.rawValue]) ?? UIImage()
    }
    func getTitle() -> String {
        let title = [Constants.tabBarFirstTitle, Constants.tabBarSecondTitle]
        return title[self.rawValue]
    }
}
