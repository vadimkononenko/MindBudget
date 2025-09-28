//
//  CategoriesSummaryView.swift
//  MindBudget
//
//  Created by Vadim Kononenko on 17.09.2025.
//

import SwiftUI

struct CategoriesSummaryView: View {
    private let sectionTitle = "Categories"
    
    var body: some View {
        VStack {
            HomeSectionTitleView(title: sectionTitle) {
                // TODO: Navigation To View All
            }
            
            CategoryInfoView()
        }
    }
}

#Preview {
    CategoriesSummaryView()
}
