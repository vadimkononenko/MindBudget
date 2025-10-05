//
//  CategoryInfoView.swift
//  MindBudget
//
//  Created by Vadim Kononenko on 17.09.2025.
//

import SwiftUI

struct CategoryInfoView: View {
    @Environment(HomeViewModel.self) private var viewModel
    
    var body: some View {
        VStack(spacing: 16) {
            if budget != nil {
                createExistingChartView(chartData: chartData)
            } else {
                EmptyBudgetChartView()
            }
        }
        .padding()
        .onAppear {
            viewModel.prepareChartData()
        }
        .onChange(of: budget) { _, _ in
            viewModel.prepareChartData()
        }
    }
}

// MARK: - Supporting Views
extension CategoryInfoView {
    @ViewBuilder
    private func createExistingChartView(chartData: [CategoryChartDataModel]) -> some View {
        HStack(alignment: .top, spacing: 20) {
            VStack {
                if !chartData.isEmpty {
                    CategoryChartView(chartData: chartData)
                } else {
                    EmptyChartView()
                }
            }
            
            if !chartData.isEmpty {
                CategoryLegendListView(chartData: chartData)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

// MARK: - Properties
extension CategoryInfoView {
    private var budget: Budget? {
        viewModel.selectedBudget
    }
    
    private var chartData: [CategoryChartDataModel] {
        viewModel.chartData
    }
}
