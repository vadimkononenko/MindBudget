//
//  EmptyChartView.swift
//  MindBudget
//
//  Created by Vadim Kononenko on 05.10.2025.
//

import SwiftUI

struct EmptyChartView: View {
    var body: some View {
        Circle()
            .stroke(Color.gray.opacity(0.3), lineWidth: 2)
            .frame(height: 200)
            .overlay(
                Text("No Values")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            )
    }
}

#Preview {
    EmptyChartView()
}
