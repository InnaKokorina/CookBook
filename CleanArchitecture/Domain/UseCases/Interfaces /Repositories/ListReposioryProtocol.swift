//
//  ListReposiory.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 06.10.2022.
//

import Foundation

protocol ListReposioryProtocol {
    func fetchRepository(request: RecipeQuery, completion: @escaping (Result<Recipe, Error>) -> Void) -> Cancellable
}
