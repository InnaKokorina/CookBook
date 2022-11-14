//
//  ConnectionError.swift
//  CleanArchitecture
//
//  Created by Inna Kokorina on 13.10.2022.
//

import Foundation

enum HandleError {
    case server
    case network
    case coreDataFetch
    case coreDataSave
    case coreDataDelete
    case userDefault
    case unknowed
    
    public var errorsType: String {
        switch self {
        case .server:
            return "Ошибка сервера"
        case .network:
            return "Ошибка соединения, проверьте интернет"
        case .coreDataFetch:
            return "Ошибка загрузкт данных из базы данных"
        case .coreDataSave:
            return "Ошибка сохранения в базу данных"
        case .coreDataDelete:
            return "Ошибка удаления из базы данных"
        case .unknowed:
            return "Что то пошло не так, попробуйте позже"
        case.userDefault:
            return "Ошибка загрузки данных из кэша"
        }
    }
}
public protocol ConnectionError: Error {
    var isInternetConnectionError: Bool { get }
}

public extension Error {
    var isInternetConnectionError: Bool {
        guard let error = self as? ConnectionError, error.isInternetConnectionError else {
            return false
        }
        return true
    }
}
