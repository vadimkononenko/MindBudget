//
//  BudgetTitleView.swift
//  MindBudget
//
//  Created by Vadim Kononenko on 17.09.2025.
//

import SwiftUI

struct BudgetTitleView: View {
    var budgetTitle: String
    var action: () -> Void
    
    var body: some View {
        HStack {
            Text(budgetTitle)
            
            Spacer()
            
            Button {
                action()
            } label: {
                Image(systemName: "ellipsis.circle")
            }
        }
    }
}
