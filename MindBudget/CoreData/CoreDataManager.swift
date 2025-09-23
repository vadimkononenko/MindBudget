//
//  CoreDataManager.swift
//  MindBudget
//
//  Created by Vadim Kononenko on 13.09.2025.
//
import CoreData

final class CoreDataManager {
    // MARK: - Shared Instance
    static let shared = CoreDataManager()
    
    // MARK: - Init
    private init() {
        printCoreDataURL()
    }

    // MARK: - Persistent Containers
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

    // MARK: - Contexts
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    var backgroundContext: NSManagedObjectContext {
        return persistentContainer.newBackgroundContext()
    }

    // MARK: - Saving
    func save(_ context: NSManagedObjectContext = CoreDataManager.shared.viewContext) throws {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            throw error
        }
    }
    
    
    func printCoreDataURL() {
        if let url = persistentContainer.persistentStoreDescriptions.first?.url {
            print(url)
        }
    }
}

// MARK: - Mock Data
extension CoreDataManager {
    func mockBudget() {
        
    }
}
