//
//  ResponseStorageProtocol.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 06.10.2022.
//

import Foundation

protocol ResponseStorageProtocol {
    func getResponse(for request: DataRequestDTO, completion: @escaping (Result<DataResponseDTO?, Error>) -> Void)
    func save(response: DataResponseDTO, for requestDto: DataRequestDTO)
}
