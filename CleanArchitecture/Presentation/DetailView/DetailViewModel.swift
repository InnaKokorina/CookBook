//
//  DetailViewModel.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 05.10.2022.
//

import Foundation

protocol DetailCellModelProtocol {}

protocol DetailViewModelInput {
    func setSectionItem(sectionIndex: Int) -> [DetailCellModelProtocol]
}

protocol DetailViewModelOutput {
    var loading: Observable<ListViewModelLoading?> { get }
    var dataSource: Observable<[DetailSection: [DetailCellModelProtocol]]> { get }
    var error: Observable<String> { get }
}

protocol DetailViewModelProtocol: DetailViewModelInput, DetailViewModelOutput {}

enum DetailSection: Int, CaseIterable {
    case header
    case types
    case ingredients
}

final class DetailViewModel: DetailViewModelProtocol {
    private var recipeId: Int
    private let detailUseCase: FetchDetailUseCaseProtocol
    private var loadTask: Cancellable? { willSet { loadTask?.cancel() } }
   
   // MARK: - output
    let loading: Observable<ListViewModelLoading?> = Observable(value: .none)
    var dataSource: Observable<[DetailSection: [DetailCellModelProtocol]]> = Observable(value: [:])
    var error: Observable<String> = Observable(value: "")
  
    init(detailUseCase: FetchDetailUseCaseProtocol, recipeId: Int ) {
        self.detailUseCase = detailUseCase
        self.recipeId = recipeId
        load(request: recipeId, loading: .fullScreen)
    }
    // MARK: - input
    func setSectionItem(sectionIndex: Int) -> [DetailCellModelProtocol] {
        guard let caseSection = DetailSection(rawValue: sectionIndex),
              let sectionItem = dataSource.value[caseSection] else { return [] }
        return sectionItem
    }
    
   // MARK: - private
    private func load(request: Int, loading: ListViewModelLoading) {
        self.loading.value = loading
        let requestString = String(request)
        loadTask = detailUseCase.fetchDetail(requestId: requestString) { [weak self] result in
            switch result {
            case .success(let results):
                self?.setSections(results: results)
            case .failure(let error):
                self?.handle(error: error)
            }
            self?.loading.value = .none
        }
    }
    
    private func handle(error: Error) {
        self.error.value = error.isInternetConnectionError ? "No internet connection".localized() : "Failed loading".localized()
    }
    
    private func setSections(results: DetailRecipes) {
        dataSource.value[.header] = [HeaderDetailCellViewModel(title: results.title, imageURL: results.imageURL)]
        dataSource.value[.types] = [DishTypesCellViewModel(types: results.dishTypes)]
        dataSource.value[.ingredients] = results.extendedIngredients.map { IngredientsViewModel(ingredients: $0) }
    }
}
