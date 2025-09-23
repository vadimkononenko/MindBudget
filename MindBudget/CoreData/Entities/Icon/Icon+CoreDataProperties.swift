//
//  Icon+CoreDataProperties.swift
//  MindBudget
//
//  Created by Vadim Kononenko on 16.09.2025.
//
//

import Foundation
import CoreData


extension Icon {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Icon> {
        return NSFetchRequest<Icon>(entityName: "Icon")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var systemName: String?
    @NSManaged public var isSystemIcon: Bool
    @NSManaged public var categories: NSSet?

}

// MARK: Generated accessors for categories
extension Icon {

    @objc(addCategoriesObject:)
    @NSManaged public func addToCategories(_ value: Category)

    @objc(removeCategoriesObject:)
    @NSManaged public func removeFromCategories(_ value: Category)

    @objc(addCategories:)
    @NSManaged public func addToCategories(_ values: NSSet)

    @objc(removeCategories:)
    @NSManaged public func removeFromCategories(_ values: NSSet)

}

extension Icon : Identifiable {

}
