//
//  DetailViewModel.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 05.10.2022.
//

import Foundation

protocol DetailViewModelInput {
    func updateData()
}

protocol DetailViewModelOutput {
    var title: String { get }
}

protocol DetailViewModelProtocol: DetailViewModelInput, DetailViewModelOutput {}

final class DetailViewModel: DetailViewModelProtocol {
   // MARK: - output
    var title: String

    
    init(entity: Recipe) {
        self.title = entity.title ?? ""
    }
   // MARK: - input
    
    func updateData() {
    }
    
    
}
