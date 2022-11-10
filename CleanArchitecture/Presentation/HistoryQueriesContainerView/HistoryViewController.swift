//
//  QueryViewController.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 06.10.2022.
//

import UIKit

class HistoryViewController: UITableViewController, Alertable {
    
    var viewModel: HistoryViewModelProtocol!

    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bind(to: viewModel)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }
// MARK: - private
    
    private func setupViews() {
        tableView.register(HistoryTableViewCell.self, forCellReuseIdentifier: HistoryTableViewCell.cellId)
        tableView?.showsVerticalScrollIndicator = false
    }
    private func bind(to: HistoryViewModelProtocol) {
        viewModel.historyItems.subscribe(on: self) { [weak self] _ in
            self?.tableView.reloadData()
        }
        viewModel.error.subscribe(on: self) { [weak self] error in
            guard !error.isEmpty else { return }
            self?.showAlert(message: error)
        }
    }
    
}
// MARK: - TableViewDaaSource and Delegate
extension HistoryViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.historyItems.value.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HistoryTableViewCell.cellId, for: indexPath) as? HistoryTableViewCell else { return UITableViewCell() }
        cell.configure(with: viewModel.historyItems.value[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { 
        tableView.deselectRow(at: indexPath, animated: false)
        viewModel.didSelectTap(query: viewModel.historyItems.value[indexPath.row])
    }
}

