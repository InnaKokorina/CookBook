//
//  MainViewController.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 05.10.2022.
//

import UIKit

class MainViewController: UIViewController, Alertable { 
    let searchBar = UISearchBar()
    let resultsListContainer = UIView()
    let historyListContainer = UIView()
    var viewModel: MainViewModelProtocol!
    private var tableViewController: ListViewController?
    private let loader = LoaderView()
    
    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bind(to: viewModel)
    }

// MARK: - private
    private func bind(to viewModel: MainViewModelProtocol) {
        viewModel.query.subscribe(on: self) { [weak self] in
            self?.updateSearchQuery($0)
        }
        viewModel.error.subscribe(on: self) { [weak self] error in
            guard !error.isEmpty else { return }
            viewModel.loading.value = .none
            self?.showAlert(message: error)
        }
        viewModel.loading.subscribe(on: self) { [weak self] in
            self?.updateLoading($0)
        }
    }
    
    private func setupViews() {
        view.addSubview(searchBar)
        view.addSubview(resultsListContainer)
        view.addSubview(historyListContainer)
        view.backgroundColor = .systemGray5
        searchBar.placeholder = "SearchBar.text".localized()
        searchBar.delegate = self
        searchBar.returnKeyType = .done
        resultsListContainer.isHidden = true
        historyListContainer.isHidden = true
        setupconstraints()
        self.title = "Search"
        setScanButton()
    }
    
    private func updateSearchQuery(_ query: String) {
        searchBar.text = query
    }
    
    private func updateQueriesSuggestions() {
        guard searchBar.isFirstResponder,
              searchBar.text?.count == 0  else {
            viewModel.closeQueriesSuggestions()
            return
        }
        historyListContainer.isHidden = false
        viewModel.resetPages()
        viewModel.showHistoryQuerieslist()
    }
    
    private func updateResultsList() {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        resultsListContainer.isHidden = false
        viewModel.showResultsList(query: searchText)
        viewModel.closeQueriesSuggestions()
    }

    private func updateLoading(_ loading: ListViewModelLoading?) {
        resultsListContainer.isHidden = true
        loader.hide()
        switch loading {
        case .fullScreen: loader.show(on: view)
        case .nextPage:
            fallthrough
        case .none:
            resultsListContainer.isHidden = viewModel.isEmpty
            loader.hide()
        }
    }
   
    private func setupconstraints() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        resultsListContainer.translatesAutoresizingMaskIntoConstraints = false
        historyListContainer.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            searchBar.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 1.0),
            view.trailingAnchor.constraint(equalTo: searchBar.trailingAnchor, constant: 12),
            searchBar.heightAnchor.constraint(equalToConstant: 72)
        ])
        
        NSLayoutConstraint.activate([
            resultsListContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            resultsListContainer.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 12),
            view.trailingAnchor.constraint(equalTo: resultsListContainer.trailingAnchor, constant: 12),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: resultsListContainer.bottomAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            historyListContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            historyListContainer.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 12),
            view.trailingAnchor.constraint(equalTo: historyListContainer.trailingAnchor, constant: 12),
            view.bottomAnchor.constraint(equalTo: historyListContainer.bottomAnchor, constant: 0)
        ])
    }
    private func setScanButton() {
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage(named: "scanIcon"), for: .normal)
        button.addTarget(self, action: #selector(scanCode), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: button)
        barButton.customView?.widthAnchor.constraint(equalToConstant: 24).isActive = true
        barButton.customView?.heightAnchor.constraint(equalToConstant: 24).isActive = true
        button.clipsToBounds = false
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: -3, height: 3)
        button.layer.shadowRadius = 3
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    @objc private func scanCode(sender: UIBarButtonItem) {
        viewModel?.openScanning()
    }
}
// MARK: - UISearchBarDelegate
extension MainViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        updateQueriesSuggestions()
    }
    
    public func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        updateResultsList()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if searchText.count == 0  {
            viewModel.didCancelSearch()
            updateQueriesSuggestions()
        }
    }
}
