//
//  RecentTransactionListView.swift
//  MindBudget
//
//  Created by Vadim Kononenko on 17.09.2025.
//

import SwiftUI

struct RecentTransactionListView: View {
    var body: some View {
        List {
            ForEach(1..<6) { index in
                RecentTransactionRowView()
                    .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
    }
}

#Preview {
    RecentTransactionListView()
}
