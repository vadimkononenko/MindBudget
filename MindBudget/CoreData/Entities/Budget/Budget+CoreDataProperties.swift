//
//  Budget+CoreDataProperties.swift
//  MindBudget
//
//  Created by Vadim Kononenko on 16.09.2025.
//
//

import Foundation
import CoreData


extension Budget {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Budget> {
        return NSFetchRequest<Budget>(entityName: "Budget")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var periodRaw: String?
    @NSManaged public var startDate: Date?
    @NSManaged public var endDate: Date?
    @NSManaged public var isActive: Bool
    @NSManaged public var totalExpectedIncome: NSDecimalNumber?
    @NSManaged public var totalExpectedExpenses: NSDecimalNumber?
    @NSManaged public var plannedAmount: NSDecimalNumber?
    @NSManaged public var currencyRaw: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var transactions: NSSet?

}

// MARK: - Computed Properties
extension Budget {
    /// Computed properties using BudgetCalculator
    /// These are lightweight wrappers - use BudgetCalculator directly for better performance
    var actualIncome: Decimal {
        let transactions = self.transactions as? Set<Transaction> ?? []
        return BudgetCalculator.calculateActualIncome(from: transactions)
    }

    var actualExpences: Decimal {
        let transactions = self.transactions as? Set<Transaction> ?? []
        return BudgetCalculator.calculateActualExpenses(from: transactions)
    }

    var remainingBudget: Decimal {
        let plannedAmount = plannedAmount?.decimalValue ?? 0
        return BudgetCalculator.calculateRemainingBudget(
            plannedAmount: plannedAmount,
            actualIncome: actualIncome,
            actualExpenses: actualExpences
        )
    }

    var progressPercentage: Double {
        let plannedAmount = plannedAmount?.decimalValue ?? 0
        return BudgetCalculator.calculateProgressPercentage(
            actualExpenses: actualExpences,
            plannedAmount: plannedAmount
        )
    }

    // MARK: - Enum Wrappers

    var period: BudgetPeriod {
        get { BudgetPeriod(rawValue: periodRaw ?? "week") ?? .week }
        set { periodRaw = newValue.rawValue }
    }

    var currency: AppCurrency {
        get { AppCurrency(rawValue: currencyRaw ?? AppCurrency.uah.rawValue) ?? .uah }
        set { currencyRaw = newValue.rawValue }
    }
}

// MARK: Generated accessors for transactions
extension Budget {

    @objc(addTransactionsObject:)
    @NSManaged public func addToTransactions(_ value: Transaction)

    @objc(removeTransactionsObject:)
    @NSManaged public func removeFromTransactions(_ value: Transaction)

    @objc(addTransactions:)
    @NSManaged public func addToTransactions(_ values: NSSet)

    @objc(removeTransactions:)
    @NSManaged public func removeFromTransactions(_ values: NSSet)

}
