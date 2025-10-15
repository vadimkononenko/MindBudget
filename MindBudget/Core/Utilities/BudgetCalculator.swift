//
//  BudgetCalculator.swift
//  MindBudget
//
//  Created by Vadim Kononenko on 23.09.2025.
//

import Foundation

/// Utility class for budget-related calculations
/// Removes business logic from CoreData entities
struct BudgetCalculator {

    // MARK: - Income Calculations

    static func calculateActualIncome(from transactions: Set<Transaction>) -> Decimal {
        transactions
            .filter { $0.type == TransactionType.income.rawValue && !$0.isArchived }
            .reduce(0) { $0 + ($1.amount?.decimalValue ?? 0) }
    }

    // MARK: - Expense Calculations

    static func calculateActualExpenses(from transactions: Set<Transaction>) -> Decimal {
        transactions
            .filter { $0.type == TransactionType.expense.rawValue && !$0.isArchived }
            .reduce(0) { $0 + ($1.amount?.decimalValue ?? 0) }
    }

    // MARK: - Budget Calculations

    static func calculateRemainingBudget(
        plannedAmount: Decimal,
        actualIncome: Decimal,
        actualExpenses: Decimal
    ) -> Decimal {
        plannedAmount + actualIncome - actualExpenses
    }

    static func calculateProgressPercentage(
        actualExpenses: Decimal,
        plannedAmount: Decimal
    ) -> Double {
        guard plannedAmount > 0 else { return 0 }
        let percentage = (actualExpenses / plannedAmount) * 100
        return min(Double(truncating: percentage as NSNumber), 100.0)
    }

    // MARK: - Combined Calculations

    struct BudgetSummary {
        let actualIncome: Decimal
        let actualExpenses: Decimal
        let remainingBudget: Decimal
        let progressPercentage: Double
    }

    static func calculateBudgetSummary(
        budget: Budget
    ) -> BudgetSummary {
        let transactions = budget.transactions as? Set<Transaction> ?? []
        let plannedAmount = budget.plannedAmount?.decimalValue ?? 0

        let income = calculateActualIncome(from: transactions)
        let expenses = calculateActualExpenses(from: transactions)
        let remaining = calculateRemainingBudget(
            plannedAmount: plannedAmount,
            actualIncome: income,
            actualExpenses: expenses
        )
        let progress = calculateProgressPercentage(
            actualExpenses: expenses,
            plannedAmount: plannedAmount
        )

        return BudgetSummary(
            actualIncome: income,
            actualExpenses: expenses,
            remainingBudget: remaining,
            progressPercentage: progress
        )
    }
}
