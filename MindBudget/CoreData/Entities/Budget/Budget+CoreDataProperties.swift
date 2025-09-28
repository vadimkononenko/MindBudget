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
    var actualIncome: Decimal {
        let transactions = self.transactions as? Set<Transaction> ?? []
        return transactions
            .filter { transaction in
                transaction.type == TransactionType.income.rawValue
            }
            .reduce(0) { $0 + ($1.amount?.decimalValue ?? 0) }
    }
    
    var actualExpences: Decimal {
        let transactions = self.transactions as? Set<Transaction> ?? []
        return transactions
            .filter { transaction in
                transaction.type == TransactionType.expense.rawValue
            }
            .reduce(0) { $0 + ($1.amount?.decimalValue ?? 0) }
    }
    
    var remainingBudget: Decimal {
        let plannedAmount = plannedAmount?.decimalValue ?? 0
        return plannedAmount - (actualIncome + actualExpences)
    }
    
    var progressPercentage: Double {
        return 0
    }
    
    // For Enum
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
