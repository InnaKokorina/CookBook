//
//  APIRequest.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 04.10.2022.
//

import Foundation

final class ApiRequest {
    
    static func getData(with requestDTO: DataRequestDTO) -> Endpoint<ResultResponseDTO> {
        return Endpoint(path: "recipes/complexSearch?",
                        method: .get,
                        queryParametersEncodable: requestDTO)
    }
    static func getImages(path: String) -> Endpoint<Data> {
        return Endpoint(path: path,
                        method: .get,
                        responseDecoder: RawDataResponseDecoder())
    }
}
