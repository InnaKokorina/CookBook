//
//  FavoriteViewController.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 28.10.2022.
//

import UIKit

class FavoriteViewController: UITableViewController, Alertable {
    var viewModel: FavoriteViewModelProtocol?
    var activityIndicator: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray5
        self.title = Constants.tabBarSecondTitle
        setupViews()
        guard let viewModel = viewModel else {
            return
        }
        viewModel.fetchData()
        bind(to: viewModel)
    }
    private func setupViews() {
        tableView?.register(FavoriteTableViewCell.self, forCellReuseIdentifier: FavoriteTableViewCell.cellId)
    }
    private func bind(to viewModel: FavoriteViewModelProtocol) {
        viewModel.favoriteItems.subscribe(on: self) { [weak self] _ in
                self?.updateItems()
        }
        viewModel.error.subscribe(on: self) { [weak self] error in
            guard !error.isEmpty else { return }
            self?.showAlert(message: error)
        }
    }
    private func updateItems() {
        tableView.reloadData()
    }
}
// MARK: - TableView Delegate, DataSource
extension FavoriteViewController {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        170
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.favoriteItems.value.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteTableViewCell.cellId, for: indexPath) as? FavoriteTableViewCell,
              let viewModel = viewModel else { return UITableViewCell() }
        cell.configure(with: viewModel.favoriteItems.value[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       viewModel?.didSelectItem(at: indexPath.row)
    }
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let trash = UIContextualAction(style: .destructive, title: "") { [weak self] (action, view, completionHandler) in
            if let viewModel = self?.viewModel {
                viewModel.handleMoveToTrash(index: indexPath.row) {
                    DispatchQueue.main.async {
                        tableView.reloadRows(at: [indexPath], with: .fade )
                    }
                }
            }
            completionHandler(true)
        }
        trash.backgroundColor = .systemRed
        trash.image = UIImage(systemName: "trash")
        return UISwipeActionsConfiguration(actions: [trash])
    }
    
}
