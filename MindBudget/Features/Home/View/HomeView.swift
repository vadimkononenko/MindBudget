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
    @State private var viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel = HomeViewModel(serviceContainer: ServiceFactory.createServices())) {
            self._viewModel = State(initialValue: viewModel)
        }
    
    var body: some View {
        NavigationStack {
            BudgetView()
            CategoriesSummaryView()
            RecentTransactionsView()
        }
        .environment(viewModel)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = HomeViewModel(serviceContainer: ServiceFactory.createPreviewServices())
        
        HomeView(viewModel: viewModel)
            .environment(
                \.managedObjectContext,
                 CoreDataManager.preview.previewContext
            )
    }
}
