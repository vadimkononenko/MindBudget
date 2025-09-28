//
//  TransactionTypeSelectionView.swift
//  MindBudget
//
//  Created by Vadim Kononenko on 17.09.2025.
//

import SwiftUI

struct TransactionTypeSelectionView: View {
    @Binding var transactionType: TransactionType
    
    var body: some View {
        Picker("", selection: $transactionType) {
            ForEach(TransactionType.allCases) {
                Text($0.rawValue)
                    .tag($0)
            }
        }
        .pickerStyle(.segmented)
    }
}

#Preview {
    TransactionTypeSelectionView(transactionType: .constant(.expense))
}
