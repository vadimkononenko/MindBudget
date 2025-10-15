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
                    BudgetDetailsSection()
                    BudgetIncomeSection()
                    BudgetExpenseSection()
                    BudgetSummarySection()

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
        }
        .environment(viewModel)
    }
}

// MARK: - Preview
struct BudgetCreationView_Previews: PreviewProvider {
    static var previews: some View {
        BudgetCreationView()
    }
}
