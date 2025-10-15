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

        do {
            return try fetch(
                entityType: Category.self,
                predicate: compoundPredicate,
                sortDescriptors: [sortDescriptor]
            )
        } catch {
            print("Error fetching categories: \(error)")
            return []
        }
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

        do {
            return try fetch(
                entityType: Category.self,
                predicate: predicate,
                sortDescriptors: [sortDescriptor]
            )
        } catch {
            print("Error fetching default categories: \(error)")
            return []
        }
    }
}
