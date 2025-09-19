//
//  TransactionRepository.swift
//  MindBudget
//
//  Created by Vadim Kononenko on 19.09.2025.
//

import Foundation
import CoreData

// MARK: - TransactionRepositoryError
enum TransactionRepositoryError: Error {
    case creationFailed
    case fetchFailed
    case updateFailed
    case deletionFailed
    case invalidData
    case transactionNotFound
}

// MARK: - TransactionRepositoryProtocol
protocol TransactionRepositoryProtocol {
    func createTransaction(amount: Decimal,
                           currencyCode: AppCurrency,
                           note: String?,
                           date: Date,
                           type: TransactionType,
                           categoryID: UUID?) -> Result<Transaction, TransactionRepositoryError>
    func fetchAllTransactions() -> Result<[Transaction], TransactionRepositoryError>
    func fetchTransaction(by id: UUID) -> Result<Transaction, TransactionRepositoryError>
    func updateTransaction(id: UUID,
                           amount: Decimal?,
                           date: Date?,
                           note: String?,
                           categoryID: UUID?) -> Result<Transaction?, TransactionRepositoryError>
    func deleteTransaction(id: UUID) -> Result<Transaction?, TransactionRepositoryError>
}

// MARK: - TransactionRepository
class TransactionRepository: TransactionRepositoryProtocol {
    private let coreDataManager: CoreDataManager
    private var context: NSManagedObjectContext {
        coreDataManager.viewContext
    }
    
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
    }
}

// MARK: - Create
extension TransactionRepository {
    func createTransaction(amount: Decimal,
                           currencyCode: AppCurrency,
                           note: String?,
                           date: Date,
                           type: TransactionType,
                           categoryID: UUID?) -> Result<Transaction, TransactionRepositoryError> {
        let transaction = Transaction(context: context)
        
        transaction.id = UUID()
        transaction.amount = amount as NSDecimalNumber
        transaction.date = Date()
        transaction.note = note
        transaction.isArchived = false
        transaction.location = nil
        transaction.createdAt = Date()
        transaction.updatedAt = Date()
        
        // "USD"
        transaction.currencyCode = currencyCode.rawValue
        
        // "Expence" OR "Income"
        transaction.type = type.rawValue
        
        // TODO: Implement Relatioship Creation
        
        do {
            try context.save()
            return .success(transaction)
        } catch {
            return .failure(.creationFailed)
        }
    }
}

// MARK: - Read
extension TransactionRepository {
    func fetchAllTransactions() -> Result<[Transaction], TransactionRepositoryError> {
        // TODO: Finish Logic
        return .success([])
    }
    
    func fetchTransaction(by id: UUID) -> Result<Transaction, TransactionRepositoryError> {
        // TODO: Finish Logic
        return .success(Transaction())
    }
}

// MARK: - Update
extension TransactionRepository {
    func updateTransaction(id: UUID, amount: Decimal?, date: Date?, note: String?, categoryID: UUID?) -> Result<Transaction?, TransactionRepositoryError> {
        // TODO: Finish Logic
        return .success(nil)
    }
}

// MARK: - Delete
extension TransactionRepository {
    func deleteTransaction(id: UUID) -> Result<Transaction?, TransactionRepositoryError> {
        // TODO: Finish Logic
        return .success(nil)
    }
}
