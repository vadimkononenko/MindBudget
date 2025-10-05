//
//  EmptyBudgetChartView.swift
//  MindBudget
//
//  Created by Vadim Kononenko on 05.10.2025.
//

import SwiftUI

struct EmptyBudgetChartView: View {
    var body: some View {
        Text("Choose Budget")
            .font(.headline)
            .foregroundStyle(.secondary)
            .frame(height: 200)
    }
}

#Preview {
    EmptyBudgetChartView()
}
