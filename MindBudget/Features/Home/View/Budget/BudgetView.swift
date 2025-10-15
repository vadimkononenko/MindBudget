//
//  BudgetView.swift
//  MindBudget
//
//  Created by Vadim Kononenko on 17.09.2025.
//

import SwiftUI

struct BudgetView: View {
    @Environment(HomeViewModel.self) private var viewModel
    @State private var showBudgetCreation = false
    @State private var showBudgetSelection = false

    var body: some View {
        VStack {
            if let selectedBudget = viewModel.selectedBudget {
                HomeSectionTitleView(title: selectedBudget.name ?? "UNTITLED", content: {
                    Button {
                        showBudgetSelection = true
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "arrow.triangle.2.circlepath")
                            Text("Change")
                        }
                        .font(.subheadline)
                        .foregroundColor(.blue)
                    }
                })

                BudgetInfoView(budget: selectedBudget)
            } else {
                if viewModel.budgets.isEmpty {
                    noBudgetsView
                } else {
                    selectBudgetView
                }
            }
        }
        .sheet(isPresented: $showBudgetCreation) {
            BudgetCreationView()
        }
        .sheet(isPresented: $showBudgetSelection) {
            BudgetSelectionSheet(viewModel: viewModel, onCreateNew: {
                showBudgetSelection = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    showBudgetCreation = true
                }
            })
        }
        .onChange(of: showBudgetCreation) { _, isShowing in
            if !isShowing {
                viewModel.loadAllActiveBudgets()
                if let latestBudget = viewModel.budgets.first {
                    viewModel.selectBudget(latestBudget)
                }
            }
        }
    }

    // MARK: - No Budgets View
    private var noBudgetsView: some View {
        VStack(spacing: 16) {
            Image(systemName: "chart.bar.doc.horizontal")
                .font(.system(size: 48))
                .foregroundColor(.secondary)

            Text("No Budget Created")
                .font(.headline)
                .foregroundColor(.primary)

            Text("Create your first budget to start tracking your finances")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Button {
                showBudgetCreation = true
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "plus.circle.fill")
                    Text("Create Budget")
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(Color.blue)
                .cornerRadius(10)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }

    // MARK: - Select Budget View
    private var selectBudgetView: some View {
        VStack(spacing: 16) {
            Image(systemName: "list.bullet.rectangle")
                .font(.system(size: 48))
                .foregroundColor(.secondary)

            Text("Select a Budget")
                .font(.headline)
                .foregroundColor(.primary)

            Text("Choose a budget to view and manage your finances")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Button {
                showBudgetSelection = true
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "list.bullet")
                    Text("Select Budget")
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(Color.blue)
                .cornerRadius(10)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
}

// MARK: - Budget Selection Sheet
struct BudgetSelectionSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var viewModel: HomeViewModel
    let onCreateNew: () -> Void

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.budgets, id: \.id) { budget in
                    Button {
                        viewModel.selectBudget(budget)
                        dismiss()
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(budget.name ?? "Untitled Budget")
                                    .font(.headline)
                                    .foregroundColor(.primary)

                                HStack {
                                    Text(budget.period.displayName)
                                        .font(.caption)
                                        .foregroundColor(.secondary)

                                    Text("•")
                                        .foregroundColor(.secondary)

                                    Text(budget.currency.symbol)
                                        .font(.caption)
                                        .foregroundColor(.secondary)

                                    if let startDate = budget.startDate {
                                        Text("•")
                                            .foregroundColor(.secondary)

                                        Text(startDate, style: .date)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }

                            Spacer()

                            if viewModel.selectedBudget?.id == budget.id {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }

                Section {
                    Button {
                        dismiss()
                        onCreateNew()
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "plus.circle.fill")
                            Text("Create New Budget")
                        }
                        .font(.headline)
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
            .navigationTitle("Select Budget")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct BudgetView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = HomeViewModel(
            serviceContainer: ServiceFactory.createPreviewServices(),
            context: CoreDataManager.preview.viewContext
        )

        return BudgetView()
            .environment(viewModel)
            .environment(
                \.managedObjectContext,
                CoreDataManager.preview.viewContext
            )
    }
}
