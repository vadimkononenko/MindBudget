//
//  FinancialGoal+CoreDataProperties.swift
//  MindBudget
//
//  Created by Vadim Kononenko on 16.09.2025.
//
//

import Foundation
import CoreData


extension FinancialGoal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FinancialGoal> {
        return NSFetchRequest<FinancialGoal>(entityName: "FinancialGoal")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var descriptionText: String?
    @NSManaged public var targetAmount: NSDecimalNumber?
    @NSManaged public var startDate: Date?
    @NSManaged public var targetDate: Date?
    @NSManaged public var priority: Int16
    @NSManaged public var createdAt: Date?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var category: Category?

}

// MARK: - Computed Properties
extension FinancialGoal {
    var currentAmount: Decimal {
        return 0
    }
    
    var isCompleted: Bool {
        return false
    }
}
