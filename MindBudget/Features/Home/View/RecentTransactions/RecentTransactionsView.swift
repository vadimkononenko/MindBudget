//
//  RecentTransactionsView.swift
//  MindBudget
//
//  Created by Vadim Kononenko on 17.09.2025.
//

import SwiftUI

struct RecentTransactionsView: View {
    @Environment(HomeViewModel.self) private var viewModel
    
    private let sectionTitle = "Recent Transactions"
    
    var body: some View {
        VStack {
            HomeSectionTitleView(title: sectionTitle, action: {
                // TODO: Navigation To View All
            })

            RecentTransactionListView(transactions: viewModel.transactions)
        }
    }
}

struct RecentTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        RecentTransactionsView()
            .environment(HomeViewModel(
                serviceContainer: ServiceFactory.createPreviewServices(),
                context: CoreDataManager.preview.viewContext
            ))
            .environment(
                \.managedObjectContext,
                CoreDataManager.preview.viewContext
            )
    }
}
