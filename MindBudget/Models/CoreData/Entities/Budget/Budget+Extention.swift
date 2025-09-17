//
//  Budget+Extention.swift
//  MindBudget
//
//  Created by Vadim Kononenko on 16.09.2025.
//

import Foundation
import CoreData

// MARK: - Fetches
extension Budget {
    static func fetchActiveBudget(context: NSManagedObjectContext) -> Budget? {
        let request: NSFetchRequest<Budget> = Budget.fetchRequest()
        request.predicate = NSPredicate(format: "isActive == true")
        request.fetchLimit = 1
        return try? context.fetch(request).first
    }
    
    static func fetchAllBudgets(for period: BudgetPeriod, context: NSManagedObjectContext) -> [Budget] {
        let request: NSFetchRequest<Budget> = Budget.fetchRequest()
        request.predicate = NSPredicate(format: "periodRaw == %@", period.rawValue)
        request.sortDescriptors = [NSSortDescriptor(key: "startDate", ascending: false)]
        return (try? context.fetch(request)) ?? []
    }
}
