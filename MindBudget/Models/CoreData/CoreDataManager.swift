//
//  CoreDataManager.swift
//  MindBudget
//
//  Created by Vadim Kononenko on 13.09.2025.
//

/*
 
 Budget
    - id (UUID, unique)
    - createdAt (Date)
    - updatedAt (Date)
    - name (String)
    - period (Int16 enum: week, month, year)
    - startDate (Date)
    - endDate (Date)
    - isActive (Bool)
    - totalExpectedIncome (Decimal)
    - totalExpectedExpenses (Decimal)
    - actualIncome (computed)
    - actualExpenses (computed)
    - category (?) — уточнить модель: обычно many-to-many через связующую сущность BudgetCategory

 Transaction
    - id (UUID, unique)
    - description (String)
    - amount (Decimal)
    - type (Int16 enum: income/expense)
    - date (Date)
    - time (DateComponents или Date, если достаточно)
    - images (Binary Data, Allows External Storage) или хранить URL
    - createdAt (Date)
    - updatedAt (Date)
    - category (to-one, inverse Category.transactions)

 Category
    - id (UUID, unique)
    - title (String)
    - description (String)
    - goal (Decimal)
    - type (Int16 enum: income/expense)
    - iconName (String)
    - isDefault (Bool)
    - createdAt (Date)
    - updatedAt (Date)
    - color (Transformable via ValueTransformer или RGBA компоненты)
    - transactions (to-many, inverse Transaction.category)
    - budget (relation ?) — уточнить: many-to-many или через BudgetCategory
 
 */

import CoreData
import os.log

final class CoreDataManager {
    static let shared = CoreDataManager()

    private let logger = Logger(subsystem: "MindBudget.CoreData", category: "CoreDataManager")

    // MARK: - Persistent Container

    // Если понадобится iCloud/CloudKit — заменим на NSPersistentCloudKitContainer и добавим конфигурацию.
    private(set) lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MindBudget")

        // Описание стора с лёгкими миграциями
        if let description = container.persistentStoreDescriptions.first {
            description.setOption(true as NSNumber, forKey: NSMigratePersistentStoresAutomaticallyOption)
            description.setOption(true as NSNumber, forKey: NSInferMappingModelAutomaticallyOption)
            // При необходимости включить history tracking и remote change notifications
            // description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
            // description.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        }

        container.loadPersistentStores { [weak self] storeDescription, error in
            if let error {
                fatalError("Error loading persistent stores: \(error)")
            } else {
                self?.logger.log("Loaded persistent store: \(storeDescription.url?.absoluteString ?? "nil")")
            }
        }

        // Настройка главного контекста
        let context = container.viewContext
        context.name = "viewContext"
        context.transactionAuthor = "ui"
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        context.automaticallyMergesChangesFromParent = true

        return container
    }()

    // MARK: - Preview/In-memory Container

    private(set) lazy var previewPersistanceContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MindBudget")
        if let description = container.persistentStoreDescriptions.first {
            description.url = URL(fileURLWithPath: "/dev/null") // in-memory
            description.setOption(true as NSNumber, forKey: NSMigratePersistentStoresAutomaticallyOption)
            description.setOption(true as NSNumber, forKey: NSInferMappingModelAutomaticallyOption)
        }

        container.loadPersistentStores { [weak self] _, error in
            if let error {
                fatalError("Error loading preview persistent stores: \(error)")
            } else {
                self?.logger.log("Loaded preview in-memory store")
            }
        }

        let context = container.viewContext
        context.name = "previewViewContext"
        context.transactionAuthor = "preview"
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        context.automaticallyMergesChangesFromParent = true

        createSampleData(in: context)

        do {
            try context.save()
        } catch {
            logger.error("Failed to save sample data: \(error.localizedDescription)")
        }

        return container
    }()

    // MARK: - Contexts

    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    func newBackgroundContext(author: String? = "background") -> NSManagedObjectContext {
        let context = persistentContainer.newBackgroundContext()
        context.name = "backgroundContext"
        context.transactionAuthor = author
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        context.automaticallyMergesChangesFromParent = true
        return context
    }

    // MARK: - Saving

    func save(context: NSManagedObjectContext) throws {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            logger.error("Core Data save error: \(error.localizedDescription)")
            throw error
        }
    }

    func saveViewContextIfNeeded() {
        do {
            try save(context: viewContext)
        } catch {
            // Не падаем в рантайме, логируем
        }
    }

    // MARK: - Sample Data

    private func createSampleData(in context: NSManagedObjectContext) {
        // Здесь нужно создать Budget/Category/Transaction согласно вашей .xcdatamodeld.
        // Пока оставим пустым, т.к. сущности не предоставлены.
        // Пример (псевдокод, замените на ваши NSManagedObject классы):
        //
        // let food = Category(context: context)
        // food.id = UUID()
        // food.title = "Food"
        // food.type = CategoryType.expense.rawValue
        // food.createdAt = Date()
        // food.updatedAt = Date()
        //
        // let budget = Budget(context: context)
        // budget.id = UUID()
        // budget.name = "September Budget"
        // budget.period = BudgetPeriod.month.rawValue
        // budget.startDate = startOfMonth(Date())
        // budget.endDate = endOfMonth(Date())
        // budget.isActive = true
        // budget.totalExpectedExpenses = 500 as NSDecimalNumber
        // budget.totalExpectedIncome = 2000 as NSDecimalNumber
        // budget.createdAt = Date()
        // budget.updatedAt = Date()
        //
        // let t = Transaction(context: context)
        // t.id = UUID()
        // t.amount = 25.50 as NSDecimalNumber
        // t.type = TransactionType.expense.rawValue
        // t.date = Date()
        // t.createdAt = Date()
        // t.updatedAt = Date()
        // t.category = food
        //
        // // Если many-to-many Budget <-> Category:
        // budget.addToCategories(food)
    }
}

