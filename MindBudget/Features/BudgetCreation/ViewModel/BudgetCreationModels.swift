//
//  BudgetCreationModels.swift
//  MindBudget
//
//  Created by Vadim Kononenko on 15.10.2025.
//

import Foundation

// MARK: - Budget Category Allocation
/// Represents a planned allocation for a specific category (income or expense)
struct BudgetCategoryAllocation: Identifiable, Hashable {
    let id: UUID
    let category: Category
    var amount: Decimal

    init(id: UUID = UUID(), category: Category, amount: Decimal) {
        self.id = id
        self.category = category
        self.amount = amount
    }

    // Custom Hashable implementation since Category is an NSManagedObject
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: BudgetCategoryAllocation, rhs: BudgetCategoryAllocation) -> Bool {
        lhs.id == rhs.id
    }
}
