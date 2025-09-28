//
//  BudgetTitleView.swift
//  MindBudget
//
//  Created by Vadim Kononenko on 17.09.2025.
//

import SwiftUI

struct BudgetTitleView: View {
    var budget: Budget
    
    var body: some View {
        HStack {
            Text(budgetTitle)
            
            Spacer()
            
            Button {
                // TODO: Finish Action
            } label: {
                Image(systemName: "ellipsis.circle")
            }
        }
    }
}

extension BudgetTitleView {
    private var budgetTitle: String {
        return budget.name ?? "Untitled Budget"
    }
}
