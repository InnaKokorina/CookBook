//
//  ListViewController.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 06.10.2022.
//

import UIKit

class ListViewController: UITableViewController  {
    var viewModel: MainViewModelProtocol!
    
    var activityIndicator: UIActivityIndicatorView?
    
    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bind(to: viewModel)
    }
    
    func updateLoading(_ loading: ListViewModelLoading?) {
        switch loading {
        case .nextPage:
            activityIndicator?.removeFromSuperview()
            activityIndicator = makeActivityIndicator(size: .init(width: tableView.frame.width, height: 44))
            tableView.tableFooterView = activityIndicator
        case .fullScreen, .none:
            tableView.tableFooterView = nil
        }
    }
        
    // MARK: - private
    private func setupViews() {
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.cellId)
    }
    
    private func bind(to: MainViewModelProtocol) {
        viewModel.items.subscribe(on: self) { [weak self] _ in
            self?.updateItems()
        }
    }
    
    private func updateItems() {
        tableView.reloadData()
    }
}
// MARK: - TableView Delegate, DataSource
extension ListViewController {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.value.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.cellId, for: indexPath) as? MainTableViewCell else { return UITableViewCell() }
        cell.configure(with: viewModel.items.value[indexPath.row])
        if indexPath.row == viewModel.items.value.count - 1 {
            viewModel.didLoadNextPage()
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectItem(at: indexPath.row)
    }
}

