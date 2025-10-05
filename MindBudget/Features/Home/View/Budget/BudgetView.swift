//
//  BudgetView.swift
//  MindBudget
//
//  Created by Vadim Kononenko on 17.09.2025.
//

import SwiftUI

struct BudgetView: View {
    @Environment(HomeViewModel.self) private var viewModel
    
    var body: some View {
        VStack {
            if let selectedBudget = viewModel.selectedBudget {
                HomeSectionTitleView(title: selectedBudget.name ?? "UNTITLED") {
                    // TODO: FINISH
                }
                
                BudgetInfoView(budget: selectedBudget)
            } else {
                EmptyView()
            }
        }
    }
}

struct BudgetView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = HomeViewModel(serviceContainer: ServiceFactory.createPreviewServices())
        
        return BudgetView()
            .environment(viewModel)
            .environment(
                \.managedObjectContext,
                 CoreDataManager.preview.previewContext
            )
    }
}
