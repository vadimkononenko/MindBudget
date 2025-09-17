//
//  RecentTransactionsView.swift
//  MindBudget
//
//  Created by Vadim Kononenko on 17.09.2025.
//

import SwiftUI

struct RecentTransactionsView: View {
    private let sectionTitle = "Recent Transactions"
    
    var body: some View {
        VStack {
            HomeSectionTitleView(title: sectionTitle) {
                // TODO: Navigation To View All
            }
            
            RecentTransactionListView()
        }
    }
}

#Preview {
    RecentTransactionsView()
}
