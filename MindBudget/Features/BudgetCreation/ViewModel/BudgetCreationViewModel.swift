//
//  BudgetCreationViewModel.swift
//  MindBudget
//
//  Created by Vadim Kononenko on 15.10.2025.
//

import Foundation
import SwiftUI
import Observation

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
    var totalIncomeText: String = ""
    var totalExpensesText: String = ""

    // MARK: - State
    var isLoading = false
    var errorMessage: String?
    var showError = false
    var budgetCreated = false

    // MARK: - Computed Properties
    var totalIncome: Decimal {
        Decimal(string: totalIncomeText) ?? 0
    }

    var totalExpenses: Decimal {
        Decimal(string: totalExpensesText) ?? 0
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

    // MARK: - Helper Methods
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
