//
//  MainViewController.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 05.10.2022.
//

import UIKit

class MainViewController: UIViewController {

    private var viewModel: MainViewModel!
    let searchBar = UISearchBar()
    let resultsListContainer = UIView()
    let historyLisConainer = UIView()
    
    private var tableViewController: ListViewController?
 
    
    // MARK: - lifecycle
    static func create(with viewModel: MainViewModel) -> MainViewController {
        let view = MainViewController()
        view.viewModel = viewModel
        return view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bind(to: viewModel)
    }
    
// MARK: - private
    private func bind(to viewModel: MainViewModel) {
        
        viewModel.query.subscribe(on: self) { [weak self] in self?.updateSearchQuery($0) }
        viewModel.error.subscribe(on: self) { [weak self] in
            self?.showError($0)
        }
    }
    
    private func setupViews() {
        view.addSubview(searchBar)
        view.addSubview(resultsListContainer)
        view.addSubview(historyLisConainer)
        view.backgroundColor = .systemGray5
        searchBar.placeholder = "что хотите приготовить?)"
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
        viewModel.showHistoryQuerieslist()
    }
    private func updateResultsList() {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        print(searchText)
        viewModel.showResultsList(query: searchText)
    }
    private func showError(_ error: String) {
    //   print(error)
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
    
   public func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
       updateQueriesSuggestions()
       return true
    }

    public func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        updateResultsList()
    }

    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        updateQueriesSuggestions()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    
}
