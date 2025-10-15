//
//  BudgetDetailsSection.swift
//  MindBudget
//
//  Created by Vadim Kononenko on 15.10.2025.
//

import SwiftUI

struct BudgetDetailsSection: View {
    @Environment(BudgetCreationViewModel.self) private var viewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Budget Details")
                .font(.headline)
                .foregroundColor(.primary)

            VStack(alignment: .leading, spacing: 16) {
                // Name
                HStack {
                    Text("Name:")
                        .foregroundColor(.secondary)
                        .frame(width: 90, alignment: .leading)

                    TextField("Budget for October 2025", text: Binding(
                        get: { viewModel.name },
                        set: { viewModel.name = $0 }
                    ))
                        .textFieldStyle(.plain)
                }

                Divider()

                // Period
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Period:")
                            .foregroundColor(.secondary)
                            .frame(width: 90, alignment: .leading)

                        Spacer()
                    }

                    HStack(spacing: 12) {
                        ForEach(BudgetPeriod.allCases, id: \.self) { period in
                            Button {
                                withAnimation(.spring(response: 0.3)) {
                                    viewModel.selectedPeriod = period
                                }
                            } label: {
                                HStack(spacing: 4) {
                                    Image(systemName: "calendar")
                                    Text(period.displayName)
                                }
                                .font(.subheadline)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(
                                    viewModel.selectedPeriod == period ?
                                        Color.blue.opacity(0.2) :
                                        Color(.systemGray6)
                                )
                                .foregroundColor(
                                    viewModel.selectedPeriod == period ?
                                        .blue : .primary
                                )
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(
                                            viewModel.selectedPeriod == period ?
                                                Color.blue : Color.clear,
                                            lineWidth: 1
                                        )
                                )
                            }
                        }
                    }
                }

                Divider()

                // Start Date
                HStack {
                    Text("Start Date:")
                        .foregroundColor(.secondary)
                        .frame(width: 90, alignment: .leading)

                    DatePicker(
                        "",
                        selection: Binding(
                            get: { viewModel.startDate },
                            set: { viewModel.startDate = $0 }
                        ),
                        displayedComponents: .date
                    )
                    .labelsHidden()

                    Spacer()

                    Text(viewModel.formatDate(viewModel.startDate))
                        .foregroundColor(.primary)
                }

                Divider()

                // End Date
                HStack {
                    Text("End Date:")
                        .foregroundColor(.secondary)
                        .frame(width: 90, alignment: .leading)

                    Spacer()

                    Text(viewModel.formatDate(viewModel.endDate))
                        .foregroundColor(.primary)
                }

                Divider()

                // Currency
                HStack {
                    Text("Currency:")
                        .foregroundColor(.secondary)
                        .frame(width: 90, alignment: .leading)

                    Text("\(viewModel.selectedCurrency.symbol) \(viewModel.selectedCurrency.rawValue)")
                        .foregroundColor(.primary)

                    Spacer()

                    Menu {
                        ForEach(AppCurrency.allCases, id: \.self) { currency in
                            Button {
                                viewModel.selectedCurrency = currency
                            } label: {
                                HStack {
                                    Text(currency.displayName)
                                    if viewModel.selectedCurrency == currency {
                                        Image(systemName: "checkmark")
                                    }
                                }
                            }
                        }
                    } label: {
                        Text("Change")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                }
            }
            .padding()
            .background(Color(.systemGray6).opacity(0.5))
            .cornerRadius(12)
        }
    }
}
