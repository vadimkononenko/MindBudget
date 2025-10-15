//
//  BudgetService.swift
//  MindBudget
//
//  Created by Vadim Kononenko on 23.09.2025.
//

import Foundation

protocol BudgetServiceProtocol {
    func createBudget(
        name: String,
        period: BudgetPeriod,
        currency: AppCurrency,
        startDate: Date,
        endDate: Date,
        plannedAmount: Decimal,
        totalExpectedExpenses: Decimal,
        totalExpectedIncome: Decimal
    ) throws -> Budget
    func fetchActiveBudgets() -> [Budget]
    func fetchBudget(by id: UUID) -> Budget?
    func updateBudget(
        _ budget: Budget,
        name: String?,
        period: String?,
        currency: String?,
        startDate: Date?,
        endDate: Date?,
        plannedAmount: Decimal?,
        totalExpectedExpenses: Decimal?,
        totalExpectedIncome: Decimal?
    ) throws -> Bool
    func deactivateBudget(_ budget: Budget) throws -> Bool
    func calculateBudgetProgress(_ budget: Budget) -> (
        spent: Decimal,
        income: Decimal,
        remaining: Decimal
    )
}

class BudgetService: BaseService, BudgetServiceProtocol {
    func createBudget(
        name: String,
        period: BudgetPeriod,
        currency: AppCurrency,
        startDate: Date,
        endDate: Date,
        plannedAmount: Decimal,
        totalExpectedExpenses: Decimal,
        totalExpectedIncome: Decimal
    ) throws -> Budget {
        let budget = Budget(context: context)
        budget.id = UUID()
        budget.name = name
        budget.periodRaw = period.rawValue // week, month, year
        budget.currencyRaw = currency.rawValue // USD, EUR, UAH
        budget.startDate = startDate
        budget.endDate = endDate
        budget.isActive = true
        budget.createdAt = Date()
        budget.updatedAt = Date()
        budget.plannedAmount = plannedAmount as NSDecimalNumber
        budget.totalExpectedExpenses = totalExpectedExpenses as NSDecimalNumber
        budget.totalExpectedIncome = totalExpectedIncome as NSDecimalNumber
            
        try save()
        return budget
    }
        
    func fetchActiveBudgets() -> [Budget] {
        let predicate = NSPredicate(format: "isActive == true")
        let sortDescriptor = NSSortDescriptor(
            keyPath: \Budget.createdAt,
            ascending: false
        )

        do {
            return try fetch(
                entityType: Budget.self,
                predicate: predicate,
                sortDescriptors: [sortDescriptor]
            )
        } catch {
            print("Error fetching active budgets: \(error)")
            return []
        }
    }

    func fetchBudget(by id: UUID) -> Budget? {
        let predicate = NSPredicate(format: "id == %@", id as CVarArg)

        do {
            return try fetchFirst(entityType: Budget.self, predicate: predicate)
        } catch {
            print("Error fetching budget by ID: \(error)")
            return nil
        }
    }
        
    func updateBudget(
        _ budget: Budget,
        name: String?,
        period: String?,
        currency: String?,
        startDate: Date?,
        endDate: Date?,
        plannedAmount: Decimal?,
        totalExpectedExpenses: Decimal?,
        totalExpectedIncome: Decimal?
    ) throws -> Bool {
        if let name = name { budget.name = name }
        if let period = period { budget.periodRaw = period }
        if let currency = currency { budget.currencyRaw = currency }
        if let startDate = startDate { budget.startDate = startDate }
        if let endDate = endDate { budget.endDate = endDate }
        if let plannedAmount = plannedAmount { budget.plannedAmount = plannedAmount as NSDecimalNumber }
        if let totalExpectedExpenses = totalExpectedExpenses { budget.totalExpectedExpenses = totalExpectedExpenses as NSDecimalNumber }
        if let totalExpectedIncome = totalExpectedIncome { budget.totalExpectedIncome = totalExpectedIncome as NSDecimalNumber }
        budget.updatedAt = Date()
            
        try save()
        return true
    }
        
    func deactivateBudget(_ budget: Budget) throws -> Bool {
        budget.isActive = false
        budget.updatedAt = Date()
        try save()
        return true
    }
        
    func calculateBudgetProgress(_ budget: Budget) -> (
        spent: Decimal,
        income: Decimal,
        remaining: Decimal
    ) {
        let expectedIncome = budget.totalExpectedIncome?.decimalValue ?? 0
        
        guard let transactions = budget.transactions as? Set<Transaction> else {
            return (0, 0, expectedIncome)
        }
            
        let activeTransactions = transactions.filter { !$0.isArchived }
        
        let expenses = activeTransactions
            .filter { $0.type == TransactionType.expense.rawValue }
            .reduce(Decimal(0)) {
                let amount = $1.amount?.decimalValue ?? 0
                return $0 + amount
        }
        
        let income = activeTransactions
            .filter { $0.type == TransactionType.income.rawValue }
            .reduce(Decimal(0)) {
                let amount = $1.amount?.decimalValue ?? 0
                return $0 + amount
        }
        
        let remaining = expectedIncome - expenses
            
        return (expenses, income, remaining)
    }
}
