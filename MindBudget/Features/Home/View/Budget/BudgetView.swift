//
//  BudgetView.swift
//  MindBudget
//
//  Created by Vadim Kononenko on 17.09.2025.
//

import SwiftUI

struct BudgetView: View {
    @Environment(HomeViewModel.self) private var viewModel
    
    var body: some View {
        VStack {
            if let selectedBudget = viewModel.selectedBudget {
                BudgetTitleView(budget: selectedBudget)
                
                BudgetInfoView(budget: selectedBudget)
            } else {
                EmptyView()
            }
        }
    }
}

#Preview {
    BudgetView()
        .environment(HomeViewModel())
}
