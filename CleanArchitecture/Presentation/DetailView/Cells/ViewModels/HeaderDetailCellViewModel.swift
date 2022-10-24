//
//  HeaderDetailCellViewModel.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 14.10.2022.
//

import Foundation

struct HeaderDetailCellViewModel: DetailCellModelProtocol {
    let title: String?
    let imagePath: String?
    
    func setFullUrlString() -> String? {
        guard let path = imagePath?.deletingPrefix(Constants.imageURL ?? "") else  { return nil }
        let baseURL = Constants.imageURL ?? ""
        let urlString = baseURL + "/" + path
       return urlString
    }
}
extension HeaderDetailCellViewModel {
    init(entity: DetailRecipes) {
        self.title = entity.title
        self.imagePath = entity.imageUrl
    }
}
