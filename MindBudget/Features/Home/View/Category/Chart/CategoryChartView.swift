//
//  CategoryChartView.swift
//  MindBudget
//
//  Created by Vadim Kononenko on 05.10.2025.
//

import SwiftUI
import Charts

struct CategoryChartView: View {
    var chartData: [CategoryChartDataModel] = []
    
    var body: some View {
        Chart(chartData, id: \.id) { data in
            SectorMark(
                angle: .value("Amount", data.amount),
                angularInset: 1
            )
            .cornerRadius(5)
            .foregroundStyle(
                colorForCategory(hex: data.categoryColor)
            )
        }
        .chartLegend(.hidden)
        .frame(height: 200)
    }
}

// MARK: - Functions
extension CategoryChartView {
    private func colorForCategory(hex: String) -> Color {
        Color(hex: hex)
    }
}
