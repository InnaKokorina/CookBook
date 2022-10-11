//
//  ListViewController.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 06.10.2022.
//

import UIKit

class ListViewController: UITableViewController  {
    var viewModel: ListViewModel!
    var imagesRepository: ImagesRepositoryPrototcol?
    
    static func create(with viewModel: ListViewModel, imagesRepository: ImagesRepositoryPrototcol?) -> ListViewController {
        let view = ListViewController()
        view.viewModel = viewModel
        view.imagesRepository = imagesRepository
        return view
    }
    // MARK: - lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bind(to: viewModel)
    }

    // MARK: - private
    
    private func setupViews() {
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.cellId)
    }
    
    private func bind(to: ListViewModel) {
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
        cell.configure(with: viewModel.items.value[indexPath.row], imagesRepository: imagesRepository)
        return cell
    }
}

