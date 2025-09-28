//
//  BudgetInfoView.swift
//  MindBudget
//
//  Created by Vadim Kononenko on 17.09.2025.
//

import SwiftUI

struct BudgetInfoView: View {
    @Environment(HomeViewModel.self) private var viewModel
    
    var budget: Budget
    
    var body: some View {
        VStack {
            HStack {
                Text(viewModel.formatAmountWithCurrencySymbol(amount: budgetPlannedAmount, for: budget))
            }
            
            HStack {
                HStack {
                    Image(systemName: "arrowshape.down.fill")
                    Text("200 $")
                }
                
                HStack {
                    Image(systemName: "arrowshape.up.fill")
                    Text("450 $")
                }
            }
        }
    }
}

// MARK: - Computed Properties
extension BudgetInfoView {
    var budgetPlannedAmount: Double {
        return viewModel.getPlannedAmount(for: budget)
    }
    
    var budgetActualIncome: Double {
        return viewModel.getActualIncome(for: budget)
    }
    
    var budgetActualExpences: Double {
        return viewModel.getActualExpences(for: budget)
    }
}
