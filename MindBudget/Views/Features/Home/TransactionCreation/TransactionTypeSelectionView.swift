//
//  TransactionTypeSelectionView.swift
//  MindBudget
//
//  Created by Vadim Kononenko on 17.09.2025.
//

import SwiftUI

enum TransactionType: String, CaseIterable, Hashable, Identifiable {
    case expense = "Expense"
    case income = "Income"
    
    var id: Int { hashValue }
    
    var systemImage: String {
        switch self {
        case .expense: return "plus.circle.fill"
        case .income: return "minus.circle.fill"
        }
    }
}

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
