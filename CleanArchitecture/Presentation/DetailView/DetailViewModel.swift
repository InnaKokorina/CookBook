//
//  DetailViewModel.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 05.10.2022.
//

import Foundation

protocol DetailViewModelInput { }

protocol DetailViewModelOutput {
    var loading: Observable<ListViewModelLoading?> { get }
    var detailHeaderItems: Observable<[HeaderDetailCellViewModel]> { get }
    var dishTypesItems: Observable<[DishTypesCellViewModel]> { get }
    var ingredientstems: Observable<[IngredientsViewModel]> { get }
    var error: Observable<String> { get }
}

protocol DetailViewModelProtocol: DetailViewModelInput, DetailViewModelOutput {}

final class DetailViewModel: DetailViewModelProtocol {
    private var recipeId: Int
    private let detailUseCase: FetchDetailUseCaseProtocol
    private var imageRepository: ImagesRepositoryPrototcol?
    private var loadTask: Cancellable? { willSet { loadTask?.cancel() } }
    
   // MARK: - output
    let loading: Observable<ListViewModelLoading?> = Observable(value: .none)
    var detailHeaderItems: Observable<[HeaderDetailCellViewModel]> = Observable(value: [])
    var dishTypesItems: Observable<[DishTypesCellViewModel]> = Observable(value: [])
    var ingredientstems: Observable<[IngredientsViewModel]> = Observable(value: [])
    var error: Observable<String> = Observable(value: "")
  
    init(detailUseCase: FetchDetailUseCaseProtocol, recipeId: Int ) {
        self.detailUseCase = detailUseCase
        self.recipeId = recipeId
        load(request: recipeId, loading: .fullScreen)
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
        detailHeaderItems.value = [HeaderDetailCellViewModel(title: results.title, imagePath: results.imageUrl)]
        dishTypesItems.value = [DishTypesCellViewModel(types: results.dishTypes)]
        ingredientstems.value = results.extendedIngredients.map { IngredientsViewModel(ingredients: $0) }
    }
}
