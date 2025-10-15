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
        guard context.hasChanges else { return }

        do {
            try context.save()
        } catch {
            throw CoreDataError.saveFailed(error)
        }
    }

    func fetch<T: NSManagedObject>(
        entityType: T.Type,
        predicate: NSPredicate? = nil,
        sortDescriptors: [NSSortDescriptor]? = nil
    ) throws -> [T] {
        let request = NSFetchRequest<T>(entityName: String(describing: entityType))
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors

        do {
            return try context.fetch(request)
        } catch {
            throw CoreDataError.fetchFailed(error)
        }
    }

    func fetchFirst<T: NSManagedObject>(
        entityType: T.Type,
        predicate: NSPredicate? = nil
    ) throws -> T? {
        let request = NSFetchRequest<T>(entityName: String(describing: entityType))
        request.predicate = predicate
        request.fetchLimit = 1

        do {
            return try context.fetch(request).first
        } catch {
            throw CoreDataError.fetchFailed(error)
        }
    }

    func delete<T: NSManagedObject>(_ object: T) throws {
        context.delete(object)
        try save()
    }

    func batchDelete<T: NSManagedObject>(
        entityType: T.Type,
        predicate: NSPredicate
    ) throws {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: entityType))
        fetchRequest.predicate = predicate

        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        batchDeleteRequest.resultType = .resultTypeObjectIDs

        do {
            let result = try context.execute(batchDeleteRequest) as? NSBatchDeleteResult

            if let objectIDs = result?.result as? [NSManagedObjectID] {
                let changes = [NSDeletedObjectsKey: objectIDs]
                NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [context])
            }
        } catch {
            throw CoreDataError.deleteFailed(error)
        }
    }
}
