//
//  TransactionService.swift
//  MindBudget
//
//  Created by Vadim Kononenko on 23.09.2025.
//

import Foundation

protocol TransactionServiceProtocol {
    func createTransaction(
        amount: Decimal,
        type: TransactionType,
        currencyCode: AppCurrency,
        date: Date,
        budget: Budget?,
        category: Category?,
        note: String?
    ) throws -> Transaction
    func fetchTransactions(for budget: Budget?, period: DateInterval?) -> [Transaction]
    func updateTransaction(
        _ transaction: Transaction,
        amount: Decimal?,
        type: TransactionType?,
        category: Category?,
        note: String?
    ) throws -> Bool
    func archiveTransaction(_ transaction: Transaction) throws -> Bool
    func fetchTransactionsByCategory(_ category: Category) -> [Transaction]
    func addTags(to transaction: Transaction, tags: [Tag]) throws -> Bool
}

class TransactionService: BaseService, TransactionServiceProtocol {
    func createTransaction(
        amount: Decimal,
        type: TransactionType,
        currencyCode: AppCurrency,
        date: Date,
        budget: Budget?,
        category: Category?,
        note: String?
    ) throws -> Transaction {
        guard amount > 0 else {
            throw ServiceError.invalidData
        }
            
        let transaction = Transaction(context: context)
        transaction.id = UUID()
        transaction.amount = amount as NSDecimalNumber
        transaction.type = type.rawValue
        transaction.currencyCode = currencyCode.rawValue
        transaction.date = date
        transaction.budget = budget
        transaction.category = category
        transaction.note = note
        transaction.isArchived = false
        transaction.createdAt = Date()
        transaction.updatedAt = Date()
            
        try save()
        return transaction
    }
        
    func fetchTransactions(for budget: Budget?, period: DateInterval?) -> [Transaction] {
        var predicates: [NSPredicate] = [
            NSPredicate(format: "isArchived == false")
        ]

        if let budget = budget {
            predicates.append(NSPredicate(format: "budget == %@", budget))
        }

        if let period = period {
            predicates
                .append(
                    NSPredicate(
                        format: "date >= %@ AND date <= %@",
                        period.start as CVarArg,
                        period.end as CVarArg
                    )
                )
        }

        let compoundPredicate = NSCompoundPredicate(
            andPredicateWithSubpredicates: predicates
        )
        let sortDescriptor = NSSortDescriptor(keyPath: \Transaction.date, ascending: false)

        do {
            return try fetch(
                entityType: Transaction.self,
                predicate: compoundPredicate,
                sortDescriptors: [sortDescriptor]
            )
        } catch {
            print("Error fetching transactions: \(error)")
            return []
        }
    }
        
    func updateTransaction(
        _ transaction: Transaction,
        amount: Decimal?,
        type: TransactionType?,
        category: Category?,
        note: String?
    ) throws -> Bool {
        if let amount = amount {
            guard amount > 0 else { throw ServiceError.invalidData }
            transaction.amount = amount as NSDecimalNumber
        }
        if let type = type { transaction.type = type.rawValue }
        if let category = category { transaction.category = category }
        if let note = note { transaction.note = note }
        transaction.updatedAt = Date()
            
        try save()
        return true
    }
        
    func archiveTransaction(_ transaction: Transaction) throws -> Bool {
        transaction.isArchived = true
        transaction.updatedAt = Date()
        try save()
        return true
    }
        
    func fetchTransactionsByCategory(_ category: Category) -> [Transaction] {
        let predicate = NSPredicate(
            format: "category == %@ AND isArchived == false",
            category
        )
        let sortDescriptor = NSSortDescriptor(keyPath: \Transaction.date, ascending: false)

        do {
            return try fetch(
                entityType: Transaction.self,
                predicate: predicate,
                sortDescriptors: [sortDescriptor]
            )
        } catch {
            print("Error fetching transactions by category: \(error)")
            return []
        }
    }
        
    func addTags(to transaction: Transaction, tags: [Tag]) throws -> Bool {
        let currentTags = transaction.tags as? Set<Tag> ?? Set<Tag>()
        let newTags = Set(tags)
        transaction.tags = NSSet(set: currentTags.union(newTags))
        transaction.updatedAt = Date()
            
        try save()
        return true
    }
}
