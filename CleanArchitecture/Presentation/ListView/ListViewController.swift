//
//  ListViewController.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 06.10.2022.
//

import UIKit

class ListViewController: UITableViewController  {
    var viewModel: ListViewModel!
    
    static func create(with viewModel: ListViewModel) -> ListViewController {
        let view = ListViewController()
        view.viewModel = viewModel
        return view
    }
    // MARK: - lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    // MARK: - private
    
    private func setupViews() {
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.cellId)
    }
    
    private func bind(to: ListViewModel) {
        //        viewModel.items.subscribe(on: self) { [weak self] _ in
        //            self?.updateItems()
        //        }
    }
}
    // MARK: - TableView Delegate, DataSource
extension ListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.cellId, for: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

