//
//  ListViewModel.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 06.10.2022.
//

import Foundation

struct ListViewModelActions {
    let showDetails: (Recipe) -> Void
}

protocol ListViewModelInput {
    func didSelectItem(at index: Int)
}

protocol ListViewModelOutput {
    var items: Observable<[MainCellViewModel]> { get }
    var error: Observable<String> { get }
}

protocol ListViewModelProtocol: ListViewModelInput, ListViewModelOutput { }

// MARK: - ListViewModel
final class ListViewModel: ListViewModelProtocol  {
    
    private let actions: ListViewModelActions?
    let entity: [Recipe]
    
    // MARK: - output
    var items: Observable<[MainCellViewModel]> = Observable(value: [])
    var error: Observable<String> = Observable(value: "")
    
    // MARK: - input
    func didSelectItem(at index: Int) {
        actions?.showDetails(entity[index])
    }
    
    // MARK: - init
    init(actions: ListViewModelActions, entity: [Recipe]) {
        self.actions = actions
        self.entity = entity
        append(entity)
    }
    
    private func append(_ recipe: [Recipe]) {
        items.value.removeAll()
        items.value = recipe.map(MainCellViewModel.init)
    }
}
