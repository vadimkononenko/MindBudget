//
//  HomeViewModel.swift
//  MindBudget
//
//  Created by Vadim Kononenko on 23.09.2025.
//

import Foundation
import SwiftUI
import Observation
import CoreData

@Observable
class HomeViewModel {
    private let budgetService: BudgetServiceProtocol
    private let categoryService: CategoryServiceProtocol
    private let transactionService: TransactionServiceProtocol
    private let context: NSManagedObjectContext

    var budgets: [Budget] = []
    var categories: [Category] = []
    var transactions: [Transaction] = []
    var selectedBudget: Budget?
    var chartData: [CategoryChartDataModel] = []
    var isLoading = false
    var errorMessage: String?

    init(serviceContainer: ServiceContaining = ServiceFactory.createServices(), context: NSManagedObjectContext = CoreDataManager.shared.viewContext) {
        self.budgetService = serviceContainer.budgetService
        self.categoryService = serviceContainer.categoryService
        self.transactionService = serviceContainer.transactionService
        self.context = context

        loadAllActiveBudgets()
        getLatestBudget()
        loadAllTransactions()
        loadAllCategories()
        prepareChartData()
    }

    // MARK: - Budget

    func loadAllActiveBudgets() {
        budgets = budgetService.fetchActiveBudgets()
    }

    func getLatestBudget() {
        selectedBudget = budgets.first
    }

    func selectBudget(_ budget: Budget) {
        selectedBudget = budget
        loadAllTransactions()
        prepareChartData()
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

    // MARK: - Category

    func loadAllCategories() {
        categories = categoryService.fetchActiveCategories(type: .expense)
    }

    /// Prepares chart data from transactions grouped by category
    func prepareChartData() {
        guard let selectedBudget = selectedBudget else {
            chartData = []
            return
        }

        let request: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        request.predicate = NSPredicate(
            format: "type == %@ AND budget == %@ AND isArchived == false",
            TransactionType.expense.rawValue,
            selectedBudget
        )

        do {
            let transactions = try context.fetch(request)

            let categorizedTransactions = transactions.filter { $0.category != nil }
            let uncategorizedTransactions = transactions.filter { $0.category == nil }

            let totalExpenses = transactions.reduce(0.0) { sum, transaction in
                sum + (transaction.amount?.doubleValue ?? 0.0)
            }

            guard totalExpenses > 0 else {
                chartData = []
                return
            }

            var chartDataArray: [CategoryChartDataModel] = []

            let categoryGroups = Dictionary(grouping: categorizedTransactions) { $0.category! }

            for (category, transactions) in categoryGroups {
                let categoryAmount = transactions.reduce(0.0) { sum, transaction in
                    sum + (transaction.amount?.doubleValue ?? 0.0)
                }

                if categoryAmount > 0 {
                    let percentage = (categoryAmount / totalExpenses) * 100
                    chartDataArray.append(CategoryChartDataModel(
                        category: category,
                        amount: categoryAmount,
                        percentage: percentage
                    ))
                }
            }

            if !uncategorizedTransactions.isEmpty {
                let uncategorizedAmount = uncategorizedTransactions.reduce(0.0) { sum, transaction in
                    sum + (transaction.amount?.doubleValue ?? 0.0)
                }

                if uncategorizedAmount > 0 {
                    let percentage = (uncategorizedAmount / totalExpenses) * 100
                    chartDataArray.append(CategoryChartDataModel(
                        uncategorizedAmount: uncategorizedAmount,
                        percentage: percentage
                    ))
                }
            }

            chartData = chartDataArray.sorted { $0.amount > $1.amount }

        } catch {
            print("Error preparing chart data: \(error)")
            errorMessage = "Failed to load chart data"
            chartData = []
        }
    }

    // MARK: - Transaction

    func loadAllTransactions() {
        transactions = transactionService.fetchTransactions(for: selectedBudget, period: nil)
    }

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
