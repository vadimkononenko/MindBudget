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
    @State private var viewModel: HomeViewModel = HomeViewModel(serviceContainer: ServiceContainer())
    
    var body: some View {
        NavigationStack {
            BudgetView()
            CategoriesSummaryView()
            RecentTransactionsView()
        }
        .environment(viewModel)
    }
}

#Preview {
    HomeView()
}
