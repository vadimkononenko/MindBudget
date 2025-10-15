//
//  CoreDataManager.swift
//  MindBudget
//
//  Created by Vadim Kononenko on 13.09.2025.
//
import CoreData
import SwiftUI

final class CoreDataManager: CoreDataManaging {
    static let shared = CoreDataManager()

    static let preview: CoreDataManager = {
        let manager = CoreDataManager(inMemory: true)
        let context = manager.viewContext
        manager.createMockData(context)
        return manager
    }()

    // MARK: - Properties
    private let persistentContainer: NSPersistentContainer
    private var _backgroundContext: NSManagedObjectContext?

    // MARK: - Init
    init(inMemory: Bool = false) {
        persistentContainer = NSPersistentContainer(name: "MindBudget")

        if inMemory {
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType
            persistentContainer.persistentStoreDescriptions = [description]
        }

        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        }

        // Configure merge policies
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        persistentContainer.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }

    // MARK: - Contexts
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    var backgroundContext: NSManagedObjectContext {
        if _backgroundContext == nil {
            _backgroundContext = persistentContainer.newBackgroundContext()
            _backgroundContext?.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        }
        return _backgroundContext!
    }

    // MARK: - Saving
    func save(_ context: NSManagedObjectContext) throws {
        guard context.hasChanges else { return }

        do {
            try context.save()
        } catch {
            throw CoreDataError.saveFailed(error)
        }
    }

    // MARK: - Background Tasks
    func performBackgroundTask<T>(_ block: @escaping (NSManagedObjectContext) throws -> T) async throws -> T {
        try await withCheckedThrowingContinuation { continuation in
            persistentContainer.performBackgroundTask { context in
                context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

                do {
                    let result = try block(context)
                    if context.hasChanges {
                        try context.save()
                    }
                    continuation.resume(returning: result)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    // MARK: - Debug
    func printCoreDataURL() {
        if let url = persistentContainer.persistentStoreDescriptions.first?.url {
            print("Core Data URL: \(url)")
        }
    }
}

// MARK: - Mock Data
extension CoreDataManager {
    func createMockData(_ context: NSManagedObjectContext) {
        // MARK: - Budget
        let budget = Budget(context: context)
        budget.id = UUID()
        budget.name = "Monthly Budget"
        budget.periodRaw = BudgetPeriod.month.rawValue
        budget.startDate = Calendar.current.dateInterval(of: .month, for: Date())!.start
        budget.endDate = Calendar.current.dateInterval(of: .month, for: Date())!.end
        budget.isActive = true
        budget.totalExpectedIncome = 30000.0
        budget.totalExpectedExpenses = 25000.0
        budget.plannedAmount = 100_000.0
        budget.currencyRaw = AppCurrency.uah.rawValue
        budget.createdAt = Date()
        budget.updatedAt = Date()
        
        
        // MARK: - Category
        let category = Category(context: context)
        category.id = UUID()
        category.name = "Groceries"
        category.note = "Monthly shopping"
        category.type = TransactionType.expense.rawValue
        category.color = "#D8A47F"
        category.iconSystemName = "basket.fill"
        category.isDefault = true
        category.isActive = true
        category.isSystemIcon = true
        category.createdAt = Date()
        category.updatedAt = Date()
        
        let category2 = Category(context: context)
        category2.id = UUID()
        category2.name = "Car"
        category2.note = nil
        category2.type = TransactionType.expense.rawValue
        category2.color = "#320D6D"
        category2.iconSystemName = "car.fill"
        category2.isDefault = true
        category2.isActive = true
        category2.isSystemIcon = true
        category2.createdAt = Date()
        category2.updatedAt = Date()
        
        let category3 = Category(context: context)
        category3.id = UUID()
        category3.name = "Entertainment"
        category3.note = nil
        category3.type = TransactionType.expense.rawValue
        category3.color = "#FFD447"
        category3.iconSystemName = "tv.fill"
        category3.isDefault = true
        category3.isActive = true
        category3.isSystemIcon = true
        category3.createdAt = Date()
        category3.updatedAt = Date()
        
        let category4 = Category(context: context)
        category4.id = UUID()
        category4.name = "Gadgets"
        category4.note = nil
        category4.type = TransactionType.expense.rawValue
        category4.color = "#EF8354"
        category4.iconSystemName = "iphone"
        category4.isDefault = true
        category4.isActive = true
        category4.isSystemIcon = true
        category4.createdAt = Date()
        category4.updatedAt = Date()
        
        
        // MARK: - FinancialGoal
        let goal = FinancialGoal(context: context)
        goal.id = UUID()
        goal.name = "New laptop"
        goal.targetAmount = 50_000.0
        goal.startDate = Date()
        goal.targetDate = Calendar.current.date(byAdding: .month, value: 1, to: Date())!
        goal.priority = 1
        goal.isFinished = false
        goal.createdAt = Date()
        goal.updatedAt = Date()
        // TODO: Category
        goal.category = category4
        
        
        // MARK: - Tag
        let tag = Tag(context: context)
        tag.id = UUID()
        tag.name = "Business"
        tag.color = "#6153CC"
        tag.createdAt = Date()
        
        let tag2 = Tag(context: context)
        tag2.id = UUID()
        tag2.name = "Hobbies"
        tag2.color = "#63474D"
        tag2.createdAt = Date()
        
        let tag3 = Tag(context: context)
        tag3.id = UUID()
        tag3.name = "Fitness"
        tag3.color = "#C7F2A7"
        tag3.createdAt = Date()
        
        
        // MARK: - Transaction
        let transaction1 = Transaction(context: context)
        transaction1.id = UUID()
        transaction1.amount = 500.0
        transaction1.type = TransactionType.expense.rawValue
        transaction1.note = "Gym subscription for 1 month"
        transaction1.date = Date()
        transaction1.currencyCode = AppCurrency.uah.rawValue
        transaction1.isArchived = false
        transaction1.createdAt = Date()
        transaction1.updatedAt = Date()
        transaction1.budget = budget
        transaction1.category = category
        transaction1.addToTags(tag)
        
        let transaction2 = Transaction(context: context)
        transaction2.id = UUID()
        transaction2.amount = 348.0
        transaction2.type = TransactionType.expense.rawValue
        transaction2.note = "Meat for dinner"
        transaction2.date = Calendar.current.date(byAdding: .day, value: -3, to: Date())!
        transaction2.currencyCode = AppCurrency.uah.rawValue
        transaction2.isArchived = false
        transaction2.createdAt = Calendar.current.date(byAdding: .day, value: -3, to: Date())!
        transaction2.updatedAt = Calendar.current.date(byAdding: .day, value: -3, to: Date())!
        transaction2.budget = nil
        transaction2.category = category
        
        let transaction3 = Transaction(context: context)
        transaction3.id = UUID()
        transaction3.amount = 45.0
        transaction3.type = TransactionType.expense.rawValue
        transaction3.note = "Water"
        transaction3.date = Date()
        transaction3.currencyCode = AppCurrency.uah.rawValue
        transaction3.isArchived = false
        transaction3.createdAt = Date()
        transaction3.updatedAt = Date()
        transaction3.budget = budget
        transaction3.category = nil
        transaction3.addToTags(tag)
        transaction3.addToTags(tag2)
        
        let transaction4 = Transaction(context: context)
        transaction4.id = UUID()
        transaction4.amount = 1999.0
        transaction4.type = TransactionType.expense.rawValue
        transaction4.note = "TV subscription for 1 year"
        transaction4.date = Date()
        transaction4.currencyCode = AppCurrency.uah.rawValue
        transaction4.isArchived = false
        transaction4.createdAt = Date()
        transaction4.updatedAt = Date()
        transaction4.budget = nil
        transaction4.category = nil
        
        let transaction5 = Transaction(context: context)
        transaction5.id = UUID()
        transaction5.amount = 150.0
        transaction5.type = TransactionType.expense.rawValue
        transaction5.note = "Miscellaneous expenses"
        transaction5.date = Date()
        transaction5.currencyCode = AppCurrency.uah.rawValue
        transaction5.isArchived = false
        transaction5.createdAt = Date()
        transaction5.updatedAt = Date()
        transaction5.budget = budget
        transaction5.category = nil
        
        do {
            try context.save()
            print("Mock data created successfully")
        } catch {
            print("Failed to save mock data: \(error)")
        }
    }
}
