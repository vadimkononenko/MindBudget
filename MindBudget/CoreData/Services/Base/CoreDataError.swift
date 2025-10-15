//
//  CoreDataError.swift
//  MindBudget
//
//  Created by Vadim Kononenko on 23.09.2025.
//

import Foundation

enum CoreDataError: LocalizedError {
    case saveFailed(Error)
    case fetchFailed(Error)
    case deleteFailed(Error)
    case invalidContext
    case invalidData
    case entityNotFound

    var errorDescription: String? {
        switch self {
        case .saveFailed(let error):
            return "Failed to save data: \(error.localizedDescription)"
        case .fetchFailed(let error):
            return "Failed to fetch data: \(error.localizedDescription)"
        case .deleteFailed(let error):
            return "Failed to delete data: \(error.localizedDescription)"
        case .invalidContext:
            return "Invalid Core Data context"
        case .invalidData:
            return "Invalid data provided"
        case .entityNotFound:
            return "Entity not found"
        }
    }
}
