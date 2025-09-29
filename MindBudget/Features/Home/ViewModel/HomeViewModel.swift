//
//  HomeViewModel.swift
//  MindBudget
//
//  Created by Vadim Kononenko on 23.09.2025.
//

import Foundation
import SwiftUI
import Observation

@Observable
class HomeViewModel {
    private let budgetService: BudgetServiceProtocol
    private let categoryService: CategoryServiceProtocol
    private let transactionService: TransactionServiceProtocol
    
    var budgets: [Budget] = []
    var categories: [Category] = []
    var transactions: [Transaction] = []
    var selectedBudget: Budget?
    
    init(serviceContainer: ServiceContainer = ServiceFactory.createServices()) {
        self.budgetService = serviceContainer.budgetService
        self.categoryService = serviceContainer.categoryService
        self.transactionService = serviceContainer.transactionService
        
        loadAllActiveBudgets()
        getLatestBudget()
    }
    
    // MARK: - Budget
    
    func loadAllActiveBudgets() {
        budgets = budgetService.fetchActiveBudgets()
    }
    
    func getLatestBudget() {
        selectedBudget = budgets.first
    }
    
    func getPlannedAmount(for budget: Budget) -> Double {
        return budget.plannedAmount?.decimalValue.toDouble() ?? 0.0
    }
    
    func getActualIncome(for budget: Budget) -> Double {
        return budget.actualIncome.toDouble()
    }
    
    func getActualExpences(for budget: Budget) -> Double {
        return budget.actualExpences.toDouble()
    }
    
    func formatAmountWithCurrencySymbol(amount: Double, for budget: Budget) -> String {
        let currencySymbol = budget.currency.symbol
        return "\(amount) \(currencySymbol)"
    }
    
    // MARK: - Transaction
    
    func getTransactionIcon(for transaction: Transaction) -> String {
        transaction.category?.iconSystemName ?? "questionmark.circle"
    }
    
    func getTransactionTitle(for transaction: Transaction) -> String {
        transaction.category?.name ?? "Unknown"
    }
    
    func getTransactionAmountWithSymbol(for transaction: Transaction) -> String {
        let amount = transaction.amount?.decimalValue.toDouble() ?? 0.0
        let symbol = AppCurrency(rawValue: transaction.currencyCode ?? AppCurrency.uah.rawValue)?.symbol ?? AppCurrency.uah.symbol
        
        return "\(amount) \(symbol)"
    }
    
    func getFormattedTransactionDate(for transaction: Transaction) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: transaction.date ?? Date())
    }
}
