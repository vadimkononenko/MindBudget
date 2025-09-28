//
//  RecentTransactionListView.swift
//  MindBudget
//
//  Created by Vadim Kononenko on 17.09.2025.
//

import SwiftUI

struct RecentTransactionListView: View {
    var transactions: [Transaction]
    
    var body: some View {
        List {
            ForEach(transactions, id: \.id) { transaction in
                RecentTransactionRowView(transaction: transaction)
                    .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
    }
}

//#Preview {
//    RecentTransactionListView()
//}
