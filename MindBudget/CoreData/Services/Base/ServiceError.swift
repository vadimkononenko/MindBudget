//
//  ServiceError.swift
//  MindBudget
//
//  Created by Vadim Kononenko on 23.09.2025.
//

import Foundation

enum ServiceError: Error, LocalizedError {
    case entityNotFound
    case saveFailure
    case invalidData
    case contextError
        
    var errorDescription: String? {
        switch self {
        case .entityNotFound:
            return "Entity not found"
        case .saveFailure:
            return "Failed to save data"
        case .invalidData:
            return "Invalid data provided"
        case .contextError:
            return "Core Data context error"
        }
    }
}
