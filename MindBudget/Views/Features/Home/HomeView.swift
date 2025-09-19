//
//  HomeView.swift
//  MindBudget
//
//  Created by Vadim Kononenko on 17.09.2025.
//

import SwiftUI

enum HomeSection: String, CaseIterable, Identifiable {
    case budget
    case categoriesSummary
    case recentTransactions
    
    var id: String { self.rawValue }
}

struct HomeView: View {
    var body: some View {
        NavigationStack {
            BudgetView()
            CategoriesSummaryView()
            RecentTransactionsView()
        }
    }
}

#Preview {
    HomeView()
}
