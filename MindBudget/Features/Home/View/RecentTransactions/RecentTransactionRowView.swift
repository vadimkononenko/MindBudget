//
//  RecentTransactionRowView.swift
//  MindBudget
//
//  Created by Vadim Kononenko on 17.09.2025.
//

import SwiftUI

struct RecentTransactionRowView: View {
    @Environment(HomeViewModel.self) private var viewModel
    
    var transaction: Transaction
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: transactionIconName)
                    .resizable()
                    .frame(width: 30, height: 30)
                
                Text("\(transactionTitle)")
            }
            
            Spacer()
            
            HStack {
                Text(transactionAmountWithSymbol)
                
                Text(transactionTimeOnlyDate)
            }
        }
    }
}

// MARK: - Computed Properties
extension RecentTransactionRowView {
    var transactionIconName: String {
        viewModel.getTransactionIcon(for: transaction)
    }
    
    var transactionTitle: String {
        viewModel.getTransactionTitle(for: transaction)
    }
    
    var transactionAmountWithSymbol: String {
        viewModel.getTransactionAmountWithSymbol(for: transaction)
    }
    
    var transactionTimeOnlyDate: String {
        viewModel.getFormattedTransactionDate(for: transaction)
    }
}

//#Preview {
//    RecentTransactionRowView()
//}
