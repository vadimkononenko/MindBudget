//
//  TransactionType.swift
//  MindBudget
//
//  Created by Vadim Kononenko on 19.09.2025.
//

import Foundation

enum TransactionType: String, CaseIterable, Hashable, Identifiable {
    case expense = "Expense"
    case income = "Income"
    
    var id: Int { hashValue }
    
    var systemImage: String {
        switch self {
        case .expense: return "plus.circle.fill"
        case .income: return "minus.circle.fill"
        }
    }
}
