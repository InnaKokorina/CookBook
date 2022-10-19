//
//  APIRequest.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 04.10.2022.
//

import Foundation

final class ApiRequest {
    
    static func getData(with requestDTO: DataRequestDTO) -> Endpoint<ResultResponseDTO> {
        return Endpoint(path: "Network.path".localized(),
                        method: .get,
                        queryParametersEncodable: requestDTO)
    }
    static func getImages(path: String) -> Endpoint<Data> {
        return Endpoint(path: path,
                        method: .get,
                        responseDecoder: RawDataResponseDecoder())
    }
    
    static func getDetail(with detailRequestDTO: DetailRequestDTO) -> Endpoint<DetailResponseDTO> {
        return Endpoint(path: "recipes/\(detailRequestDTO.recipeId)/information",
                        method: .get,
                        queryParametersEncodable: detailRequestDTO)
    }
    
    static func getIngredientsImages(with path: String) -> Endpoint<Data> {
        return Endpoint(path: "cdn/ingredients_250x250/\(path)",
                        method: .get,
                        responseDecoder: RawDataResponseDecoder())
    }
}
