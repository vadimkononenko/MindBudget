//
//  BudgetPeriod.swift
//  MindBudget
//
//  Created by Vadim Kononenko on 16.09.2025.
//

import Foundation

enum BudgetPeriod: String, CaseIterable, Codable {
    case week = "week"
    case month = "month"
    case year = "year"
    
    var displayName: String {
        switch self {
        case .week: return "Week"
        case .month: return "Month"
        case .year: return "Year"
        }
    }
    
    var durationInDays: Int {
        switch self {
        case .week: return 7
        case .month: return 30
        case .year: return 365
        }
    }
}
