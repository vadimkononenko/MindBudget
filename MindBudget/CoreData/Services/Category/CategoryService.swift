//
//  CategoryService.swift
//  MindBudget
//
//  Created by Vadim Kononenko on 23.09.2025.
//

import Foundation
import CoreData

protocol CategoryServiceProtocol {
    func createCategory(
        name: String,
        type: TransactionType,
        color: String,
        isDefault: Bool,
        note: String?
    ) throws -> Category
    func fetchActiveCategories(type: TransactionType?) -> [Category]
    func updateCategory(
        _ category: Category,
        name: String?,
        color: String?,
        note: String?
    ) throws -> Bool
    func deactivateCategory(_ category: Category) throws -> Bool
    func fetchDefaultCategories() -> [Category]
    func prepareCategoryChartDataOptimized(for budget: Budget) -> [CategoryChartDataModel]
}

class CategoryService: BaseService, CategoryServiceProtocol {
    func createCategory(
        name: String,
        type: TransactionType,
        color: String,
        isDefault: Bool,
        note: String?
    ) throws -> Category {
        let category = Category(context: context)
        category.id = UUID()
        category.name = name
        category.type = type.rawValue
        category.color = color
        category.isDefault = isDefault
        category.isActive = true
        category.note = note
        category.createdAt = Date()
        category.updatedAt = Date()
            
        try save()
        return category
    }
        
    func fetchActiveCategories(type: TransactionType?) -> [Category] {
        var predicates: [NSPredicate] = [NSPredicate(format: "isActive == true")]
            
        if let type = type {
            predicates.append(NSPredicate(format: "type == %@", type.rawValue))
        }
            
        let compoundPredicate = NSCompoundPredicate(
            andPredicateWithSubpredicates: predicates
        )
        let sortDescriptor = NSSortDescriptor(keyPath: \Category.name, ascending: true)
            
        return fetch(
            entityType: Category.self,
            predicate: compoundPredicate,
            sortDescriptors: [sortDescriptor]
        )
    }
        
    func updateCategory(
        _ category: Category,
        name: String?,
        color: String?,
        note: String?
    ) throws -> Bool {
        if let name = name { category.name = name }
        if let color = color { category.color = color }
        if let note = note { category.note = note }
        category.updatedAt = Date()
            
        try save()
        return true
    }
        
    func deactivateCategory(_ category: Category) throws -> Bool {
        category.isActive = false
        category.updatedAt = Date()
        try save()
        return true
    }
        
    func fetchDefaultCategories() -> [Category] {
        let predicate = NSPredicate(format: "isDefault == true AND isActive == true")
        let sortDescriptor = NSSortDescriptor(keyPath: \Category.name, ascending: true)
        return fetch(
            entityType: Category.self,
            predicate: predicate,
            sortDescriptors: [sortDescriptor]
        )
    }
    
    func prepareCategoryChartDataOptimized(for budget: Budget) -> [CategoryChartDataModel] {
        let request: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        request.predicate = NSPredicate(
            format: "type == %@ AND budget == %@ AND isArchived == false",
            TransactionType.expense.rawValue,
            budget
        )
            
        do {
            let transactions = try context.fetch(request)
                
            let categorizedTransactions = transactions.filter {
                $0.category != nil
            }
            let uncategorizedTransactions = transactions.filter {
                $0.category == nil
            }
            
            let totalExpenses = transactions.reduce(0.0) { sum, transaction in
                sum + (transaction.amount?.doubleValue ?? 0.0)
            }

            guard totalExpenses > 0 else { return [] }
            
            var chartDataArray: [CategoryChartDataModel] = []
            
            let categoryGroups = Dictionary(grouping: categorizedTransactions) {
                $0.category!
            }
            
            for (category, transactions) in categoryGroups {
                let categoryAmount = transactions.reduce(
                    0.0
                ) { sum, transaction in
                    sum + (transaction.amount?.doubleValue ?? 0.0)
                }
                
                if categoryAmount > 0 {
                    let percentage = (categoryAmount / totalExpenses) * 100
                    chartDataArray.append(CategoryChartDataModel(
                        category: category,
                        amount: categoryAmount,
                        percentage: percentage
                    ))
                }
            }
            
            if !uncategorizedTransactions.isEmpty {
                let uncategorizedAmount = uncategorizedTransactions.reduce(
                    0.0
                ) { sum, transaction in
                    sum + (transaction.amount?.doubleValue ?? 0.0)
                }
                
                if uncategorizedAmount > 0 {
                    let percentage = (uncategorizedAmount / totalExpenses) * 100
                    chartDataArray.append(CategoryChartDataModel(
                        uncategorizedAmount: uncategorizedAmount,
                        percentage: percentage
                    ))
                }
            }
            
            return chartDataArray.sorted { $0.amount > $1.amount }
            
        } catch {
            print("Error fetching transactions for chart: \(error)")
            return []
        }
    }
}
