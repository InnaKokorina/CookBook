//
//  ImagesRepository.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 11.10.2022.
//

import Foundation

protocol ImagesRepositoryPrototcol {
    func fetchImage(with imagePath: String, completion: @escaping (Result<Data, Error>) -> Void) -> Cancellable?
    func fetchIngredientImage(with imagePath: String, completion: @escaping (Result<Data, Error>) -> Void) -> Cancellable?
}
