//
//  RecentTransactionRowView.swift
//  MindBudget
//
//  Created by Vadim Kononenko on 17.09.2025.
//

import SwiftUI

struct RecentTransactionRowView: View {
    var body: some View {
        HStack {
            HStack {
                RoundedRectangle(cornerRadius: 5)
                    .frame(width: 30, height: 30)
                    
                Text("Transaction")
            }
            
            Spacer()
            
            HStack {
                Text("-500 ₴")
                
                Text("14:31")
            }
        }
    }
}

#Preview {
    RecentTransactionRowView()
}
