//
//  SceneCoordinator.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 05.10.2022.
//

import Foundation
import UIKit
import Swinject

final class SceneCoordinator {
    
    private weak var navigationController: UINavigationController?
    private var mainViewController: MainViewController?
    private weak var listViewController: UIViewController?
    private weak var historyListVC: UIViewController?
    private var actions: MainViewModelActions?
    let container: Container
    
    init(navigationController: UINavigationController, container: Container) {
        self.navigationController = navigationController
        self.container = container
    }
    
    // MARK: - showMainViewController
    func showMainViewController() {
        actions = MainViewModelActions(showResultsList: makeListViewConroller,
                                           showHistoryList: makeHistoryViewController,
                                           closeHistoryList: closeHistoryViewController,
                                           showDetails: showDetailViewController)
        
        
        guard let actions = actions,
              let vc = container.resolve(MainViewController.self)
               else { return }
        vc.viewModel.actions = actions
        mainViewController = vc
        navigationController?.pushViewController(vc, animated: false)
    }
    
    // MARK: - showListViewController()
    func makeListViewConroller(viewModel: MainViewModelProtocol) {
        guard let vc = container.resolve(ListViewController.self),
              listViewController == nil,
              let uiContainer = mainViewController?.resultsListContainer else { return }
        listViewController = vc
        mainViewController?.add(child: vc, container: uiContainer)
    }
    
    // MARK: - showHistoryViewConroller
    func makeHistoryViewController(onHistoryItemChoosen: @escaping (RecipeQuery) -> Void ) {
        guard let uiContainer = mainViewController?.historyListContainer,
              historyListVC == nil,
              let vc = container.resolve(HistoryViewController.self) else { return }
        vc.viewModel.onHistoryItemChoosen = onHistoryItemChoosen
        vc.viewModel.actions = HistoryViewModelAction(closeHistoryList: closeHistoryViewController)
        historyListVC = vc
        mainViewController?.add(child: vc, container: uiContainer)
    }
    
    // MARK: - showDetailViewController
    private func showDetailViewController(recipeId: Int?) {
        guard let vc = container.resolve(DetailViewController.self) else { return }
        vc.viewModel.recipeId = recipeId
        navigationController?.present(vc, animated: true)
    }
    // MARK: - closeViewControllers
    private func closeHistoryViewController() {
        historyListVC?.remove()
        historyListVC = nil
        mainViewController?.historyListContainer.isHidden = true
    }
}
