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
 //   var description: String { get }
}

protocol DetailViewModelProtocol: DetailViewModelInput, DetailViewModelOutput {}

final class DetailViewModel: DetailViewModelProtocol {
   // MARK: - output
    var title: String
   // var description: String
    
    init(entity: Recipe) {
        self.title = entity.title ?? ""
      //  self.description = entity.description ?? ""
    }
   // MARK: - input
    
    func updateData() {
        //
    }
    
    
}
