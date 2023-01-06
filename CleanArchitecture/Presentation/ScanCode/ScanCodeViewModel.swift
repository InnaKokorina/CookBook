//
//  ScanCodeViewModel.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 29.12.2022.
//

import Foundation

struct ScanCodeViewModelActions {
    let showDetails: (_ recipeId: Int) -> Void
}

protocol ScanCodeViewModelOutput {
    var actions: ScanCodeViewModelActions? { get set }
}
protocol ScanCodeViewModelInput {
    func didSelectItem(at recipeId: Int)
}

protocol ScanCodeViewModelProtocol: ScanCodeViewModelOutput, ScanCodeViewModelInput {
    
}

class ScanCodeViewModel: ScanCodeViewModelProtocol {
    
    var actions: ScanCodeViewModelActions?
    
    func didSelectItem(at recipeId: Int) {
        actions?.showDetails(recipeId)
    }
}
