//
//  BudgetTitleView.swift
//  MindBudget
//
//  Created by Vadim Kononenko on 17.09.2025.
//

import SwiftUI

struct BudgetTitleView: View {
    var body: some View {
        HStack {
            Text("Monthly Budget")
            
            Spacer()
            
            Button {
                //
            } label: {
                Image(systemName: "ellipsis.circle")
            }
        }
    }
}

#Preview {
    BudgetTitleView()
}
