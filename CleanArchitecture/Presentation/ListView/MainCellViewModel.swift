//
//  MainCellViewModel.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 05.10.2022.
//

import Foundation

struct MainCellViewModel { // почему тут структура с расширением, а viewModel - класс?
    let title: String
  //  let description: String
}

extension MainCellViewModel {
    init(entity: Recipe) {
        self.title = entity.title ?? ""
       // self.description = entity.description ?? ""
    }
}
