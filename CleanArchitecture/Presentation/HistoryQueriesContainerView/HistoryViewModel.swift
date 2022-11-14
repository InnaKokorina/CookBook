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
    func didSelectTap(query: HistoryCellViewModel)
}

protocol HistoryViewModelOutput {
    var onHistoryItemChoosen: ((RecipeQuery) -> Void)? { get set }
    var actions: HistoryViewModelAction? { get set }
    var historyItems: Observable<[HistoryCellViewModel]> { get }
    var error: Observable<String> { get }
}

protocol HistoryViewModelProtocol: HistoryViewModelInput, HistoryViewModelOutput {}

final class  HistoryViewModel: HistoryViewModelProtocol {
    var historyItems: Observable<[HistoryCellViewModel]> = Observable(value: [])
    var error: Observable<String> = Observable(value: "")
    var onHistoryItemChoosen: ((RecipeQuery) -> Void)?
    var actions: HistoryViewModelAction?
    
    private let fetchUseCase: FetchHisoryUseCaseProtocol
    
    init(fetchUseCase: FetchHisoryUseCaseProtocol) {
        self.fetchUseCase = fetchUseCase
    }

    private func updateQueries() {
        fetchUseCase.start { [weak self] result in
            switch result {
            case .success(let queries):
                self?.append(queries)
            case .failure(let error):
                self?.error.value = HandleError.userDefault.errorsType
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
    
    func didSelectTap(query: HistoryCellViewModel) {
        if let didSelect = onHistoryItemChoosen {
            didSelect(RecipeQuery(query: query.title ?? "" , offset: 10))
        }
        actions?.closeHistoryList()
    }
}
