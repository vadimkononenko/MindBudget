//
//  HomeSectionTitleView.swift
//  MindBudget
//
//  Created by Vadim Kononenko on 17.09.2025.
//

import SwiftUI

struct HomeSectionTitleView: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        HStack {
            Text(title.capitalized)
                .font(.title2)
            
            Spacer()
            
            Button {
                action()
            } label: {
                Image(systemName: "ellipsis.circle")
            }
        }
    }
}
