//
//  TransactionImage+CoreDataProperties.swift
//  MindBudget
//
//  Created by Vadim Kononenko on 16.09.2025.
//
//

import Foundation
import CoreData


extension TransactionImage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TransactionImage> {
        return NSFetchRequest<TransactionImage>(entityName: "TransactionImage")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var imageData: Data?
    @NSManaged public var createdAt: Date?
    @NSManaged public var transaction: Transaction?

}

extension TransactionImage : Identifiable {

}
