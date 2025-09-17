//
//  BudgetInfoView.swift
//  MindBudget
//
//  Created by Vadim Kononenko on 17.09.2025.
//

import SwiftUI

struct BudgetInfoView: View {
    var body: some View {
        VStack {
            HStack {
                Text("1000 $")
                Text("available")
            }
            
            HStack {
                HStack {
                    Image(systemName: "arrowshape.down.fill")
                    Text("200 $")
                }
                
                HStack {
                    Image(systemName: "arrowshape.up.fill")
                    Text("450 $")
                }
            }
        }
    }
}

#Preview {
    BudgetInfoView()
}
