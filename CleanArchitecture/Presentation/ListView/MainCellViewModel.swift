//
//  MainCellViewModel.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 05.10.2022.
//

import Foundation

struct MainCellViewModel {
    let title: String?
    let imagePath: String?
    let id: Int
    
    func setFullUrlString() -> String? {
        guard let path = imagePath?.deletingPrefix(Constants.imageURL ?? "") else  { return nil}
        let baseURL = Constants.imageURL ?? ""
        let urlString = baseURL + "/" + path
       return urlString
    }
}

extension MainCellViewModel {
    init(entity: Recipe) {
        self.title = entity.title
        self.imagePath = entity.posterPath
        self.id = entity.id
    }
}

extension String {
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
}
