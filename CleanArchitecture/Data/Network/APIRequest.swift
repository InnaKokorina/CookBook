//
//  APIRequest.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 04.10.2022.
//

import Foundation

final class ApiRequest {
   // reques to Api
    static func getData(with requestDTO: DataRequestDTO) -> Endpoint<DataResponseDTO> {
        return Endpoint(path: "",
                        method: .get,
                        queryParametersEncodable: requestDTO)
    } 
}
