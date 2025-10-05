//
//  CategoryChartDataModel.swift
//  MindBudget
//
//  Created by Vadim Kononenko on 05.10.2025.
//

import Foundation

struct CategoryChartDataModel: Identifiable {
    let id = UUID()
    let categoryName: String
    let categoryIcon: String
    let categoryColor: String
    let amount: Double
    let percentage: Double
    
    init(category: Category, amount: Double, percentage: Double) {
        self.categoryName = category.name ?? "Unknown"
        self.categoryIcon = category.iconSystemName ?? "questionmark.circle"
        self.categoryColor = category.color ?? "#95A5A6"
        self.amount = amount
        self.percentage = percentage
    }
    
    init(uncategorizedAmount: Double, percentage: Double) {
        self.categoryName = "Uncategorized"
        self.categoryIcon = "questionmark.circle"
        self.categoryColor = "#95A5A6"
        self.amount = uncategorizedAmount
        self.percentage = percentage
    }
}
