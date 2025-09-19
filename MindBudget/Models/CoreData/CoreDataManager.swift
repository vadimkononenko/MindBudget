//
//  CoreDataManager.swift
//  MindBudget
//
//  Created by Vadim Kononenko on 13.09.2025.
//
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {}

    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MindBudget")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        }
        return container
    }()
    
    lazy var previewInMemory: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MindBudget")
        container.persistentStoreDescriptions.first!.url = URL(
            fileURLWithPath: "/dev/null"
        )
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
            
        return container
    }()

    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    func save(context: NSManagedObjectContext) throws {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            throw error
        }
    }
}

// MARK: - Mock Data
extension CoreDataManager {
    func mockBudget() {
        
    }
}
