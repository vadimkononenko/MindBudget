//
//  BudgetSummarySection.swift
//  MindBudget
//
//  Created by Vadim Kononenko on 15.10.2025.
//

import SwiftUI

struct BudgetSummarySection: View {
    @Environment(BudgetCreationViewModel.self) private var viewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Summary")
                .font(.headline)
                .foregroundColor(.primary)

            VStack(spacing: 12) {
                SummaryRow(
                    icon: "💰",
                    title: "Expected Income:",
                    value: "\(viewModel.formatAmount(viewModel.totalIncome)) \(viewModel.selectedCurrency.symbol)",
                    color: .green
                )

                Divider()

                SummaryRow(
                    icon: "💸",
                    title: "Planned Expenses:",
                    value: "\(viewModel.formatAmount(viewModel.totalExpenses)) \(viewModel.selectedCurrency.symbol)",
                    color: .red
                )

                Divider()

                SummaryRow(
                    icon: "💵",
                    title: "Expected Savings:",
                    value: "\(viewModel.formatAmount(viewModel.expectedSavings)) \(viewModel.selectedCurrency.symbol)",
                    color: viewModel.expectedSavings >= 0 ? .green : .red
                )

                Divider()

                SummaryRow(
                    icon: "📊",
                    title: "Savings Rate:",
                    value: String(format: "%.1f%%", viewModel.savingsRate),
                    color: .blue
                )
            }
            .padding()
            .background(Color(.systemGray6).opacity(0.5))
            .cornerRadius(12)
        }
    }
}

// MARK: - Summary Row Component
struct SummaryRow: View {
    let icon: String
    let title: String
    let value: String
    let color: Color

    var body: some View {
        HStack {
            Text(icon)
            Text(title)
                .foregroundColor(.secondary)

            Spacer()

            Text(value)
                .fontWeight(.semibold)
                .foregroundColor(color)
        }
    }
}
