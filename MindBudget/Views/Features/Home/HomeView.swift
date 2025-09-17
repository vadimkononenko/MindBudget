//
//  HomeView.swift
//  MindBudget
//
//  Created by Vadim Kononenko on 17.09.2025.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            BudgetView()
            CategoriesSummaryView()
            RecentTransactionsView()
        }
    }
}

#Preview {
    HomeView()
}
