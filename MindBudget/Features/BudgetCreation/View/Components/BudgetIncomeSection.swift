//
//  BudgetIncomeSection.swift
//  MindBudget
//
//  Created by Vadim Kononenko on 15.10.2025.
//

import SwiftUI

struct BudgetIncomeSection: View {
    @Environment(BudgetCreationViewModel.self) private var viewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Expected Income")
                .font(.headline)
                .foregroundColor(.primary)

            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Total Income:")
                        .foregroundColor(.secondary)

                    Spacer()

                    HStack(spacing: 8) {
                        TextField("0", text: Binding(
                            get: { viewModel.totalIncomeText },
                            set: { viewModel.totalIncomeText = $0 }
                        ))
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(maxWidth: 150)

                        Text(viewModel.selectedCurrency.symbol)
                            .foregroundColor(.green)
                    }
                }
            }
            .padding()
            .background(Color(.systemGray6).opacity(0.5))
            .cornerRadius(12)
        }
    }
}
