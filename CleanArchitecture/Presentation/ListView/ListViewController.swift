//
//  ListViewController.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 06.10.2022.
//

import UIKit

class ListViewController: UITableViewController, Alertable {
    var viewModel: MainViewModelProtocol?
    var activityIndicator: UIActivityIndicatorView?
    
    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        guard let viewModel = viewModel else {
            return
        }
        bind(to: viewModel)
    }
    
    func updateLoading(_ loading: ListViewModelLoading?) {
        switch loading {
        case .nextPage:
            activityIndicator?.removeFromSuperview()
            activityIndicator = makeActivityIndicator(size: .init(width: tableView.frame.width, height: 44))
            tableView?.tableFooterView = activityIndicator
        case .fullScreen, .none:
            tableView.tableFooterView = nil
        }
    }
        
    // MARK: - private
    private func setupViews() {
        tableView?.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.cellId)
        tableView?.showsVerticalScrollIndicator = false
    }
    
    private func bind(to viewModel: MainViewModelProtocol) {
        viewModel.error.subscribe(on: self) { [weak self] error in
            guard !error.isEmpty else { return }
            viewModel.loading.value = .none
            self?.showAlert(message: error)
        }
        viewModel.loading.subscribe(on: self) { [weak self] in
            self?.updateLoading($0)
        }
        viewModel.allUpdatingRequired.subscribe(on: self) { _ in
            self.updateItems()
        }
        viewModel.favoriteIsUpdated.subscribe(on: self) { index in
            if let index = index {
                self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
                
            }
        }
    }
    
    private func updateItems() {
        tableView.reloadData()
    }
    
    
}
// MARK: - TableView Delegate, DataSource
extension ListViewController {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        170
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.items.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.cellId, for: indexPath) as? MainTableViewCell,
              let viewModel = viewModel else { return UITableViewCell() }
        cell.configure(with: viewModel.items[indexPath.row])
        cell.likeSelect = {
            viewModel.updateFavorite(index: indexPath.row)
        }
        if indexPath.row == (viewModel.items.count) - 1 {
            viewModel.didLoadNextPage()
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       viewModel?.didSelectItem(at: indexPath.row)
    }
}

