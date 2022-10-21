//
//  Constants.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 20.10.2022.
//

import Foundation

struct Constants {
    static let apiKey = Bundle.main.infoDictionary?["API_KEY"] as? String
    static let apiKeyNumber = Bundle.main.infoDictionary?["ACCESS_KEY"] as? String
    static let baseURL = Bundle.main.infoDictionary?["BASE_URL"] as? String
    static let imageURL = Bundle.main.infoDictionary?["IMAGE_URL"] as? String
    static let path = Bundle.main.infoDictionary?["PATH"] as? String
}
