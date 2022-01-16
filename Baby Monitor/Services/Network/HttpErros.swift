//
//  HttpErros.swift
//  Baby Monitor
//
//  Created by Andreas on 16.01.2022.
//

import Foundation

enum HttpErrors {
    case empty
    case cantCreateToken
    case unknownError(statusCode: Int)
}

extension HttpErrors: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .empty:
            return NSLocalizedString("Данные отсутствуют", comment: "")
        case .cantCreateToken:
            return NSLocalizedString("Не удалось сформировать токен", comment: "")
        case .unknownError(statusCode: let statusCode):
            return NSLocalizedString("Неизвестная ошибка. Статус код \(statusCode)", comment: "")
        }
    }
}
