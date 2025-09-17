//
//  TransactionCreationView.swift
//  MindBudget
//
//  Created by Vadim Kononenko on 17.09.2025.
//

import SwiftUI

struct TransactionCreationView: View {
    @State private var transactionType: TransactionType = .expense
    @State private var amountTextField: String = ""
    @State private var descriptionTextField: String = ""
    @State private var selectedDateAndTime: Date = Date()
    
    var body: some View {
        VStack {
            TransactionTypeSelectionView(transactionType: $transactionType)
            
            TextField("Amount", text: $amountTextField)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.decimalPad)
            
            TextField("Description", text: $descriptionTextField)
                .textFieldStyle(.roundedBorder)
            
            // TODO: Category Selection
            
            // Date and Time
            DatePicker("Choose when:", selection: $selectedDateAndTime)
            
            // TODO: Photos Selections
            
            // TODO: Tags Selections
            
            Spacer()
        }
        .padding(.horizontal)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Save") {
                    // TODO: Finish Save Implementation
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        TransactionCreationView()
    }
}
