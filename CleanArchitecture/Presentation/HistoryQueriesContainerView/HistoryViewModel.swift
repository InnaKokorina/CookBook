//
//  QueryViewModel.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 06.10.2022.
//

import Foundation

protocol HistoryViewModelInput {
    func viewWillAppear()
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
    
    init(fetchUseCase:FetchHisoryUseCaseExecute) {
        self.fetchUseCase = fetchUseCase
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
}
