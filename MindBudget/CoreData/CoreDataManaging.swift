//
//  CoreDataManaging.swift
//  MindBudget
//
//  Created by Vadim Kononenko on 23.09.2025.
//

import CoreData
import Foundation

protocol CoreDataManaging {
    var viewContext: NSManagedObjectContext { get }
    var backgroundContext: NSManagedObjectContext { get }

    func save(_ context: NSManagedObjectContext) throws
    func performBackgroundTask<T>(_ block: @escaping (NSManagedObjectContext) throws -> T) async throws -> T
}
