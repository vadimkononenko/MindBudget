//
//  BudgetCreationViewModel.swift
//  MindBudget
//
//  Created by Vadim Kononenko on 15.10.2025.
//

import Foundation
import SwiftUI
import Observation
import Combine

@Observable
class BudgetCreationViewModel: ObservableObject {
    // MARK: - Services
    private let budgetService: BudgetServiceProtocol
    private let categoryService: CategoryServiceProtocol

    // MARK: - Form Fields
    var name: String = ""
    var selectedPeriod: BudgetPeriod = .month
    var selectedCurrency: AppCurrency = .uah
    var startDate: Date = Date()

    // MARK: - Income Allocations
    var incomeAllocations: [BudgetCategoryAllocation] = []
    var availableIncomeCategories: [Category] = []
    var showAddIncome = false

    // MARK: - Expense Allocations
    var expenseAllocations: [BudgetCategoryAllocation] = []
    var availableExpenseCategories: [Category] = []
    var showAddExpense = false

    // MARK: - State
    var isLoading = false
    var errorMessage: String?
    var showError = false
    var budgetCreated = false

    // MARK: - Computed Properties
    var totalIncome: Decimal {
        incomeAllocations.reduce(0) { $0 + $1.amount }
    }

    var totalExpenses: Decimal {
        expenseAllocations.reduce(0) { $0 + $1.amount }
    }

    var expectedSavings: Decimal {
        totalIncome - totalExpenses
    }

    var savingsRate: Double {
        guard totalIncome > 0 else { return 0 }
        let rate = (expectedSavings / totalIncome) * 100
        return Double(truncating: rate as NSNumber)
    }

    var endDate: Date {
        calculateEndDate(from: startDate, period: selectedPeriod)
    }

    var isFormValid: Bool {
        !name.isEmpty && totalIncome >= 0
    }

    // MARK: - Initialization
    init(serviceContainer: ServiceContaining = ServiceFactory.createServices()) {
        self.budgetService = serviceContainer.budgetService
        self.categoryService = serviceContainer.categoryService
        loadIncomeCategories()
        loadExpenseCategories()
    }

    // MARK: - Actions
    func createBudget() {
        guard isFormValid else {
            errorMessage = "Please fill in all required fields"
            showError = true
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            let _ = try budgetService.createBudget(
                name: name,
                period: selectedPeriod,
                currency: selectedCurrency,
                startDate: startDate,
                endDate: endDate,
                plannedAmount: totalExpenses > 0 ? totalExpenses : totalIncome,
                totalExpectedExpenses: totalExpenses,
                totalExpectedIncome: totalIncome
            )

            budgetCreated = true
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            showError = true
            isLoading = false
        }
    }

    // MARK: - Income Allocation Management
    func addIncomeAllocation(_ allocation: BudgetCategoryAllocation) {
        incomeAllocations.append(allocation)
    }

    func removeIncomeAllocation(at indexSet: IndexSet) {
        incomeAllocations.remove(atOffsets: indexSet)
    }

    func updateIncomeAllocation(_ allocation: BudgetCategoryAllocation) {
        if let index = incomeAllocations.firstIndex(where: { $0.id == allocation.id }) {
            incomeAllocations[index] = allocation
        }
    }

    // MARK: - Expense Allocation Management
    func addExpenseAllocation(_ allocation: BudgetCategoryAllocation) {
        expenseAllocations.append(allocation)
    }

    func removeExpenseAllocation(at indexSet: IndexSet) {
        expenseAllocations.remove(atOffsets: indexSet)
    }

    func updateExpenseAllocation(_ allocation: BudgetCategoryAllocation) {
        if let index = expenseAllocations.firstIndex(where: { $0.id == allocation.id }) {
            expenseAllocations[index] = allocation
        }
    }

    func expensePercentage(for allocation: BudgetCategoryAllocation) -> Double {
        guard totalExpenses > 0 else { return 0 }
        let percentage = (allocation.amount / totalExpenses) * 100
        return Double(truncating: percentage as NSNumber)
    }

    // MARK: - Helper Methods
    private func loadIncomeCategories() {
        availableIncomeCategories = categoryService.fetchActiveCategories(type: .income)
    }

    private func loadExpenseCategories() {
        availableExpenseCategories = categoryService.fetchActiveCategories(type: .expense)
    }

    private func calculateEndDate(from startDate: Date, period: BudgetPeriod) -> Date {
        let calendar = Calendar.current
        switch period {
        case .week:
            return calendar.date(byAdding: .day, value: 7, to: startDate) ?? startDate
        case .month:
            return calendar.date(byAdding: .month, value: 1, to: startDate) ?? startDate
        case .year:
            return calendar.date(byAdding: .year, value: 1, to: startDate) ?? startDate
        }
    }

    func formatAmount(_ amount: Decimal) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        formatter.groupingSeparator = ","

        let number = NSDecimalNumber(decimal: amount)
        return formatter.string(from: number) ?? "0"
    }

    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return formatter.string(from: date)
    }
}
