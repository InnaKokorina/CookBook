//
//  Extensions+String.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 13.10.2022.
//

import Foundation
extension String {
    func localized(bundle: Bundle = .main, tableName: String = "Localizable") -> String {
        return NSLocalizedString(self,
                                 tableName: tableName,
                                 bundle: bundle,
                                 value: "<\(self)>",
                                 comment: "")
    }
}
