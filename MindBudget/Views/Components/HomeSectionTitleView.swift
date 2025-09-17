//
//  HomeSectionTitleView.swift
//  MindBudget
//
//  Created by Vadim Kononenko on 17.09.2025.
//

import SwiftUI

struct HomeSectionTitleView: View {
    let title: String
    let navigate: () -> Void
    
    var body: some View {
        HStack {
            Text(title.capitalized)
            
            Spacer()
            
            Button {
                navigate()
            } label: {
                HStack {
                    Text("View All")
                    
                    Image(systemName: "arrow.right.circle")
                }
            }
        }
    }
}
