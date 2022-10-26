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
    let historyLisConainer = UIView()
    var viewModel: MainViewModelProtocol!
    private var tableViewController: ListViewController?

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
        viewModel.error.subscribe(on: self) { [weak self] in
            self?.showError($0)
        }
        viewModel.loading.subscribe(on: self) { [weak self] in
            self?.updateLoading($0)
        }
    }
    
    private func setupViews() {
        view.addSubview(searchBar)
        view.addSubview(resultsListContainer)
        view.addSubview(historyLisConainer)
        view.backgroundColor = .systemGray5
        searchBar.placeholder = "SearchBar.text".localized()
        searchBar.delegate = self
        searchBar.returnKeyType = .done
        resultsListContainer.isHidden = true
        historyLisConainer.isHidden = true
        setupconstraints()
    }
    
    private func updateSearchQuery(_ query: String) {
        searchBar.text = query
    }
    
    private func updateQueriesSuggestions() {
        guard searchBar.isFirstResponder else {
            viewModel.closeQueriesSuggestions()
            return
        }
        viewModel.resetPages()
        viewModel.showHistoryQuerieslist()
    }
    
    private func updateResultsList() {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        viewModel.showResultsList(query: searchText)
        viewModel.closeQueriesSuggestions()
    }
    
    private func showError(_ error: String) {
        guard !error.isEmpty else { return }
        showAlert(title: viewModel.errorTitle, message: error)
    }
    
    private func updateLoading(_ loading: ListViewModelLoading?) {
        resultsListContainer.isHidden = true
        LoadingView.hide()

        switch loading {
        case .fullScreen: LoadingView.show()
        case .nextPage: resultsListContainer.isHidden = false
        case .none:
            resultsListContainer.isHidden = viewModel.isEmpty
        }
        tableViewController?.updateLoading(loading)
    }
   
    private func setupconstraints() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        resultsListContainer.translatesAutoresizingMaskIntoConstraints = false
        historyLisConainer.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            searchBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 72),
            view.trailingAnchor.constraint(equalTo: searchBar.trailingAnchor, constant: 12),
            searchBar.heightAnchor.constraint(equalToConstant: 72)
        ])
        
        NSLayoutConstraint.activate([
            resultsListContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            resultsListContainer.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 12),
            view.trailingAnchor.constraint(equalTo: resultsListContainer.trailingAnchor, constant: 12),
            view.bottomAnchor.constraint(equalTo: resultsListContainer.bottomAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            historyLisConainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            historyLisConainer.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 12),
            view.trailingAnchor.constraint(equalTo: historyLisConainer.trailingAnchor, constant: 12),
            view.bottomAnchor.constraint(equalTo: historyLisConainer.bottomAnchor, constant: 0)
        ])
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
        if searchText.count == 0
        {
            viewModel.didCancelSearch()
            updateQueriesSuggestions()
        }
    }
}
