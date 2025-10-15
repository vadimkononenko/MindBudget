//
//  CategoriesSummaryView.swift
//  MindBudget
//
//  Created by Vadim Kononenko on 17.09.2025.
//

import SwiftUI

struct CategoriesSummaryView: View {
    @Environment(HomeViewModel.self) private var viewModel
    
    private let sectionTitle = "Categories"
    
    var body: some View {
        VStack {
            HomeSectionTitleView(title: sectionTitle, action: {
                // TODO: Navigation To View All
            })

            CategoryInfoView()
        }
    }
}

struct CategoriesSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesSummaryView()
            .environment(HomeViewModel(
                serviceContainer: ServiceFactory.createPreviewServices(),
                context: CoreDataManager.preview.viewContext
            ))
            .environment(
                \.managedObjectContext,
                CoreDataManager.preview.viewContext
            )
    }
}
