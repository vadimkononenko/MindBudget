//
//  Transaction+CoreDataProperties.swift
//  MindBudget
//
//  Created by Vadim Kononenko on 16.09.2025.
//
//

import Foundation
import CoreData


extension Transaction {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Transaction> {
        return NSFetchRequest<Transaction>(entityName: "Transaction")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var amount: NSDecimalNumber?
    @NSManaged public var type: String?
    @NSManaged public var note: String?
    @NSManaged public var date: Date?
    @NSManaged public var currencyCode: String?
    @NSManaged public var location: String?
    @NSManaged public var isArchived: Bool
    @NSManaged public var createdAt: Date?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var images: NSSet?
    @NSManaged public var category: Category?
    @NSManaged public var budget: Budget?
    @NSManaged public var tags: NSSet?

}

// MARK: Generated accessors for images
extension Transaction {

    @objc(addImagesObject:)
    @NSManaged public func addToImages(_ value: TransactionImage)

    @objc(removeImagesObject:)
    @NSManaged public func removeFromImages(_ value: TransactionImage)

    @objc(addImages:)
    @NSManaged public func addToImages(_ values: NSSet)

    @objc(removeImages:)
    @NSManaged public func removeFromImages(_ values: NSSet)

}

// MARK: Generated accessors for tags
extension Transaction {

    @objc(addTagsObject:)
    @NSManaged public func addToTags(_ value: Tag)

    @objc(removeTagsObject:)
    @NSManaged public func removeFromTags(_ value: Tag)

    @objc(addTags:)
    @NSManaged public func addToTags(_ values: NSSet)

    @objc(removeTags:)
    @NSManaged public func removeFromTags(_ values: NSSet)

}

extension Transaction : Identifiable {

}
