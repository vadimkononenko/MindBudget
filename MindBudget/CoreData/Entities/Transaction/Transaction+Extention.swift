//
//  Transaction+Extention.swift
//  MindBudget
//
//  Created by Vadim Kononenko on 23.09.2025.
//

import Foundation
import CoreData

extension Transaction {
    static func fetchAll() -> NSFetchRequest<Transaction> {
        let request: NSFetchRequest<Transaction> = fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Transaction.createdAt, ascending: true)
        ]
        return request
    }
    
//    static func fetch(by id: UUID) -> NSFetchRequest<Transaction> {
//        let request: NSFetchRequest<Transaction> = fetchRequest()
//        request.predicate = NSPredicate(format: "", <#T##args: any CVarArg...##any CVarArg#>)
//    }
}

extension Transaction {
    func createTransaction(amount: Decimal,
                           currencyCode: AppCurrency,
                           note: String?,
                           date: Date,
                           type: TransactionType,
                           categoryID: UUID?,
                           in context: NSManagedObjectContext) throws -> Transaction {
        let transaction = Transaction(context: context)
        
        transaction.id = UUID()
        transaction.amount = amount as NSDecimalNumber
        transaction.date = date
        transaction.note = note
        transaction.isArchived = false
        transaction.createdAt = Date()
        transaction.updatedAt = Date()
        
        // "USD"
        transaction.currencyCode = currencyCode.rawValue
        
        // "Expence" OR "Income"
        transaction.type = type.rawValue
        
        try context.save()
        return transaction
    }
}
