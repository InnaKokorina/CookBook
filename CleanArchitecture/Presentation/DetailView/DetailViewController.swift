//
//  DetailViewController.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 05.10.2022.
//

import UIKit

class DetailViewController: UIViewController {
    
    private var viewModel: DetailViewModel!
    
    static func create(with viewModel: DetailViewModel) -> DetailViewController {
        let view = DetailViewController()
        view.viewModel = viewModel
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind(to: viewModel)
        setupViews()
    }

    // MARK: - private
    
    private func bind(to: DetailViewModel) {
        //?
    }
    
    private func setupViews() {
        // tableView = UITableView()
        //setupConstraintrs()
    }
}
