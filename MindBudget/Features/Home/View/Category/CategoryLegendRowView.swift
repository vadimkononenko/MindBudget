//
//  CategoryLegendRowView.swift
//  MindBudget
//
//  Created by Vadim Kononenko on 05.10.2025.
//

import SwiftUI

struct CategoryLegendRowView: View {
    let chartData: CategoryChartDataModel
    
    var body: some View {
        HStack {
            Image(systemName: categoryIconName)
                .font(.caption)
                .frame(width: 16)
                .foregroundColor(colorForCategory(hex: chartData.categoryColor))
            
            Text(categoryName)
                .font(.caption)
                .lineLimit(1)
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Text(formattedChartDataAmount)
                    .font(.caption)
                    .fontWeight(.medium)
                
                Text(formattedChartDataPercentage)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 2)
    }
}

// MARK: - Properties
extension CategoryLegendRowView {
    private var categoryIconName: String {
        chartData.categoryIcon
    }
    
    private var categoryName: String {
        chartData.categoryName
    }
    
    private var formattedChartDataAmount: String {
        String(format: "%.0f ₴", chartData.amount)
    }
    
    private var formattedChartDataPercentage: String {
        String(format: "%.1f%%", chartData.percentage)
    }
}

// MARK: - Functions
extension CategoryLegendRowView {
    private func colorForCategory(hex: String) -> Color {
        Color(hex: hex)
    }
}
