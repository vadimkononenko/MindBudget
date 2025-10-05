//
//  CategoryLegendListView.swift
//  MindBudget
//
//  Created by Vadim Kononenko on 05.10.2025.
//

import SwiftUI

struct CategoryLegendListView: View {
    var chartData: [CategoryChartDataModel] = []
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(chartData, id: \.id) { data in
                CategoryLegendRowView(chartData: data)
            }
        }
    }
}
