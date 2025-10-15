//
//  BudgetCreationView.swift
//  MindBudget
//
//  Created by Vadim Kononenko on 15.10.2025.
//

import SwiftUI

struct BudgetCreationView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = BudgetCreationViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Budget Details Section
                    budgetDetailsSection

                    // Expected Income Section
                    expectedIncomeSection

                    // Planned Expenses Section
                    plannedExpensesSection

                    // Summary Section
                    summarySection

                    Spacer(minLength: 20)
                }
                .padding()
            }
            .navigationTitle("New Budget")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "xmark")
                            Text("Cancel")
                        }
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        viewModel.createBudget()
                    } label: {
                        HStack(spacing: 4) {
                            if viewModel.isLoading {
                                ProgressView()
                                    .scaleEffect(0.8)
                            } else {
                                Image(systemName: "square.and.arrow.down")
                                Text("Save")
                            }
                        }
                    }
                    .disabled(!viewModel.isFormValid || viewModel.isLoading)
                }
            }
            .alert("Error", isPresented: $viewModel.showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage ?? "Unknown error")
            }
            .onChange(of: viewModel.budgetCreated) { _, created in
                if created {
                    dismiss()
                }
            }
            .sheet(isPresented: $viewModel.showAddIncome) {
                AddIncomeAllocationSheet(viewModel: viewModel)
            }
            .sheet(isPresented: $viewModel.showAddExpense) {
                AddExpenseAllocationSheet(viewModel: viewModel)
            }
        }
    }

    // MARK: - Budget Details Section
    private var budgetDetailsSection: some View {
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

                    TextField("Budget for October 2025", text: $viewModel.name)
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
                        selection: $viewModel.startDate,
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

    // MARK: - Expected Income Section
    private var expectedIncomeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Expected Income")
                .font(.headline)
                .foregroundColor(.primary)

            VStack(alignment: .leading, spacing: 16) {
                // Total Income
                HStack {
                    Text("Total Income:")
                        .foregroundColor(.secondary)

                    Spacer()

                    Text("\(viewModel.formatAmount(viewModel.totalIncome)) \(viewModel.selectedCurrency.symbol)")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.green)
                }

                if !viewModel.incomeAllocations.isEmpty {
                    Divider()

                    // Income Allocations Header
                    HStack {
                        Text("Income Sources: (Optional)")
                            .foregroundColor(.secondary)
                            .font(.subheadline)

                        Spacer()

                        Button {
                            viewModel.showAddIncome = true
                        } label: {
                            HStack(spacing: 4) {
                                Image(systemName: "plus.circle.fill")
                                Text("Add Income")
                            }
                            .font(.subheadline)
                            .foregroundColor(.blue)
                        }
                    }

                    // Income Allocations List
                    ForEach(viewModel.incomeAllocations) { allocation in
                        HStack {
                            if let iconName = allocation.category.iconSystemName {
                                Image(systemName: iconName)
                                    .foregroundColor(Color(hex: allocation.category.color ?? "#000000"))
                            }
                            Text(allocation.category.name ?? "Unknown")
                                .foregroundColor(.primary)

                            Spacer()

                            Text("\(viewModel.formatAmount(allocation.amount)) \(viewModel.selectedCurrency.symbol)")
                                .foregroundColor(.green)
                        }
                        .swipeActions {
                            Button(role: .destructive) {
                                if let index = viewModel.incomeAllocations.firstIndex(where: { $0.id == allocation.id }) {
                                    viewModel.removeIncomeAllocation(at: IndexSet(integer: index))
                                }
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                } else {
                    Divider()

                    Button {
                        viewModel.showAddIncome = true
                    } label: {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Add Income Source")
                        }
                        .font(.subheadline)
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 8)
                    }
                }
            }
            .padding()
            .background(Color(.systemGray6).opacity(0.5))
            .cornerRadius(12)
        }
    }

    // MARK: - Planned Expenses Section
    private var plannedExpensesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Planned Expenses")
                .font(.headline)
                .foregroundColor(.primary)

            VStack(alignment: .leading, spacing: 16) {
                // Total Expenses
                HStack {
                    Text("Total Expenses:")
                        .foregroundColor(.secondary)

                    Spacer()

                    Text("\(viewModel.formatAmount(viewModel.totalExpenses)) \(viewModel.selectedCurrency.symbol)")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.red)
                }

                if !viewModel.expenseAllocations.isEmpty {
                    Divider()

                    // Expense Allocations Header
                    HStack {
                        Text("Category Allocations:")
                            .foregroundColor(.secondary)
                            .font(.subheadline)

                        Spacer()

                        Button {
                            viewModel.showAddExpense = true
                        } label: {
                            HStack(spacing: 4) {
                                Image(systemName: "plus.circle.fill")
                                Text("Add Category")
                            }
                            .font(.subheadline)
                            .foregroundColor(.blue)
                        }
                    }

                    // Expense Allocations List
                    ForEach(viewModel.expenseAllocations) { allocation in
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                if let iconName = allocation.category.iconSystemName {
                                    Image(systemName: iconName)
                                        .foregroundColor(Color(hex: allocation.category.color ?? "#000000"))
                                }
                                Text(allocation.category.name ?? "Unknown")
                                    .foregroundColor(.primary)

                                Spacer()

                                Text("\(viewModel.formatAmount(allocation.amount)) \(viewModel.selectedCurrency.symbol)")
                                    .foregroundColor(.red)
                            }

                            // Progress Bar
                            GeometryReader { geometry in
                                ZStack(alignment: .leading) {
                                    Rectangle()
                                        .fill(Color(.systemGray5))
                                        .frame(height: 6)

                                    Rectangle()
                                        .fill(Color.red.opacity(0.7))
                                        .frame(
                                            width: geometry.size.width * CGFloat(viewModel.expensePercentage(for: allocation) / 100),
                                            height: 6
                                        )
                                }
                                .cornerRadius(3)
                            }
                            .frame(height: 6)
                        }
                        .swipeActions {
                            Button(role: .destructive) {
                                if let index = viewModel.expenseAllocations.firstIndex(where: { $0.id == allocation.id }) {
                                    viewModel.removeExpenseAllocation(at: IndexSet(integer: index))
                                }
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                } else {
                    Divider()

                    Button {
                        viewModel.showAddExpense = true
                    } label: {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Add Category Allocation")
                        }
                        .font(.subheadline)
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 8)
                    }
                }
            }
            .padding()
            .background(Color(.systemGray6).opacity(0.5))
            .cornerRadius(12)
        }
    }

    // MARK: - Summary Section
    private var summarySection: some View {
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

// MARK: - Add Income Allocation Sheet
struct AddIncomeAllocationSheet: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: BudgetCreationViewModel

    @State private var selectedCategory: Category?
    @State private var amountText: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Income Category") {
                    Picker("Category", selection: $selectedCategory) {
                        Text("Select Income Category").tag(nil as Category?)
                        ForEach(viewModel.availableIncomeCategories, id: \.id) { category in
                            HStack {
                                if let iconName = category.iconSystemName {
                                    Image(systemName: iconName)
                                }
                                Text(category.name ?? "Unknown")
                            }
                            .tag(category as Category?)
                        }
                    }

                    HStack {
                        Text(viewModel.selectedCurrency.symbol)
                        TextField("Amount", text: $amountText)
                            .keyboardType(.decimalPad)
                    }
                }
            }
            .navigationTitle("Add Income")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        if let category = selectedCategory,
                           let amount = Decimal(string: amountText) {
                            let allocation = BudgetCategoryAllocation(
                                category: category,
                                amount: amount
                            )
                            viewModel.addIncomeAllocation(allocation)
                            dismiss()
                        }
                    }
                    .disabled(selectedCategory == nil || amountText.isEmpty)
                }
            }
        }
    }
}

// MARK: - Add Expense Allocation Sheet
struct AddExpenseAllocationSheet: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: BudgetCreationViewModel

    @State private var selectedCategory: Category?
    @State private var amountText: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Expense Category") {
                    Picker("Category", selection: $selectedCategory) {
                        Text("Select Expense Category").tag(nil as Category?)
                        ForEach(viewModel.availableExpenseCategories, id: \.id) { category in
                            HStack {
                                if let iconName = category.iconSystemName {
                                    Image(systemName: iconName)
                                }
                                Text(category.name ?? "Unknown")
                            }
                            .tag(category as Category?)
                        }
                    }

                    HStack {
                        Text(viewModel.selectedCurrency.symbol)
                        TextField("Amount", text: $amountText)
                            .keyboardType(.decimalPad)
                    }
                }
            }
            .navigationTitle("Add Expense")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        if let category = selectedCategory,
                           let amount = Decimal(string: amountText) {
                            let allocation = BudgetCategoryAllocation(
                                category: category,
                                amount: amount
                            )
                            viewModel.addExpenseAllocation(allocation)
                            dismiss()
                        }
                    }
                    .disabled(selectedCategory == nil || amountText.isEmpty)
                }
            }
        }
    }
}

// MARK: - Preview
struct BudgetCreationView_Previews: PreviewProvider {
    static var previews: some View {
        BudgetCreationView()
    }
}
