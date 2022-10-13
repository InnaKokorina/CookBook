//
//  QueryViewModel.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 06.10.2022.
//

import Foundation

struct HistoryViewModelAction {
    let closeHistoryList: () -> Void
}

protocol HistoryViewModelInput {
    func viewWillAppear()
    func didSelect(query: HistoryCellViewModel)
}

protocol HistoryViewModelOutput {
    var historyItems: Observable<[HistoryCellViewModel]> { get }
    var error: Observable<String> { get }
}

protocol HistoryViewModelProtocol: HistoryViewModelInput, HistoryViewModelOutput {}

final class  HistoryViewModel: HistoryViewModelProtocol {
    var historyItems: Observable<[HistoryCellViewModel]> = Observable(value: [])
    var error: Observable<String> = Observable(value: "")
    private let fetchUseCase: FetchHisoryUseCaseExecute
    private let didSelect: (RecipeQuery) -> Void
    private let actions: HistoryViewModelAction?
    
    init(fetchUseCase:FetchHisoryUseCaseExecute, didSelect: @escaping (RecipeQuery) -> Void, actions: HistoryViewModelAction?) {
        self.fetchUseCase = fetchUseCase
        self.didSelect = didSelect
        self.actions = actions
    }

    private func updateQueries() {
        fetchUseCase.start { [weak self] result in
            switch result {
            case .success(let queries):
                self?.append(queries)
            case .failure: break
            }
        }
    }
    private func append(_ queries: [RecipeQuery]) {
        historyItems.value = queries.map(HistoryCellViewModel.init)
    }
    // MARK: - input
    func viewWillAppear() {
        updateQueries()
    }
    
    func didSelect(query: HistoryCellViewModel) {
        didSelect(RecipeQuery(query: query.title ?? "" , offset: 10))
        actions?.closeHistoryList()
    }
}
