//
//  BaseService.swift
//  MindBudget
//
//  Created by Vadim Kononenko on 23.09.2025.
//

import Foundation
import CoreData

protocol BaseServiceProtocol {
    var context: NSManagedObjectContext { get }
    func save() throws
}

class BaseService: BaseServiceProtocol {
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func save() throws {
        if context.hasChanges {
            
        }
    }
    
    func fetch<T: NSManagedObject>(
        entityType: T.Type,
        predicate: NSPredicate? = nil,
        sortDescriptors: [NSSortDescriptor]? = nil
    ) -> [T] {
        let request = NSFetchRequest<T>(entityName: String(describing: entityType))
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        
        do {
            return try context.fetch(request)
        } catch {
            print("Fetch error: \(error)")
            return []
        }
    }
    
    func fetchFirst<T: NSManagedObject>(
        entityType: T.Type,
        predicate: NSPredicate? = nil
    ) -> T? {
        let request = NSFetchRequest<T>(entityName: String(describing: entityType))
        request.predicate = predicate
        request.fetchLimit = 1
        
        do {
            return try context.fetch(request).first
        } catch {
            print("Fetch error: \(error)")
            return nil
        }
    }
}
