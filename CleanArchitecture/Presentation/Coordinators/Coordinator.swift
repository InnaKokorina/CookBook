//
//  Coordinator.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 05.10.2022.
//

import Foundation
import UIKit

protocol CoorinatorDependencies {
    func makeMainViewController(actions: MainViewModelActions) -> MainViewController
    func makeHistoryViewController() -> UIViewController
    func makeListViewConroller(actions: ListViewModelActions, entity: [Recipe], imagesRepository: ImagesRepositoryPrototcol?) -> UIViewController
    func makeDetailViewController(entity: Recipe) -> UIViewController
}

final class Coordinator {
    
    private weak var navigationController: UINavigationController?
    private let dependencies: CoorinatorDependencies
    private weak var historyListVC: UIViewController?
    private var mainViewController: MainViewController?
    private weak var listViewController: UIViewController?
    
    init(navigationController: UINavigationController, dependencies: CoorinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    // MARK: - showMainViewController
    func showMainViewController() {
        let actions = MainViewModelActions(showResultsList: makeListViewConroller,
                                           showHisoryList: makeHistoryViewController,
                                           closeHisoryList: closeHistoryViewController,
                                           closeListViewConroller: closeListViewConroller)
        let vc = dependencies.makeMainViewController(actions: actions)
        mainViewController = vc
        navigationController?.pushViewController(vc, animated: false)
    }
    
    // MARK: - showListViewController()
    func makeListViewConroller(entity: [Recipe], imagesRepository: ImagesRepositoryPrototcol?) {
        guard let container = mainViewController?.resultsListContainer,
            let mainViewController = mainViewController,
                listViewController == nil  else { return }
        let actions = ListViewModelActions(showDetails: showDetailViewController)
        let vc = dependencies.makeListViewConroller(actions: actions, entity: entity, imagesRepository: imagesRepository)
        listViewController = vc
        mainViewController.add(child: vc, container: container)
        mainViewController.resultsListContainer.isHidden = false
    }
    
    // MARK: - showHistoryViewConroller
    func makeHistoryViewController() {
        guard let container = mainViewController?.historyLisConainer,
              let mainViewController = mainViewController,
              historyListVC == nil else { return }
        let vc = dependencies.makeHistoryViewController()
        historyListVC = vc
        mainViewController.add(child: vc, container: container)
        mainViewController.historyLisConainer.isHidden = false
    }
    
    // MARK: - showDetailViewController
    private func showDetailViewController(entity: Recipe) { 
        let vc = dependencies.makeDetailViewController(entity: entity)
        navigationController?.pushViewController(vc, animated: false)
    }
    // MARK: - closeViewControllers
    private func closeHistoryViewController() {
        historyListVC?.remove()
        historyListVC = nil
        mainViewController?.historyLisConainer.isHidden = true
    }

    private func closeListViewConroller() {
        listViewController?.remove()
        listViewController = nil
        mainViewController?.resultsListContainer.isHidden = true
    }
}
