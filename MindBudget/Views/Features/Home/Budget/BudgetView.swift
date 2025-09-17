//
//  BudgetView.swift
//  MindBudget
//
//  Created by Vadim Kononenko on 17.09.2025.
//

import SwiftUI

struct BudgetView: View {
    var body: some View {
        VStack {
            BudgetTitleView()
            
            BudgetInfoView()
        }
    }
}

#Preview {
    BudgetView()
}
