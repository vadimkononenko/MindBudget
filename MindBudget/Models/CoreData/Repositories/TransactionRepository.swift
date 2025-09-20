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
    func fetchTransaction(by id: UUID) -> Result<Transaction?, TransactionRepositoryError>
    func updateTransaction(id: UUID,
                           amount: Decimal?,
                           date: Date?,
                           note: String?) -> Result<Transaction?, TransactionRepositoryError>
    func deleteTransaction(id: UUID) -> Result<Bool, TransactionRepositoryError>
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
        let request = NSFetchRequest<Transaction>(entityName: "Transaction")
        
        do {
            let transactions = try context.fetch(request)
            return .success(transactions)
        } catch {
            return .failure(.fetchFailed)
        }
    }
    
    func fetchTransaction(by id: UUID) -> Result<Transaction?, TransactionRepositoryError> {
        let request = NSFetchRequest<Transaction>(entityName: "Transaction")
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        do {
            let transaction = try context.fetch(request)
            return .success(transaction.first)
        } catch {
            return .failure(.fetchFailed)
        }
    }
}

// MARK: - Update
extension TransactionRepository {
    func updateTransaction(id: UUID,
                           amount: Decimal?,
                           date: Date?,
                           note: String?) -> Result<Transaction?, TransactionRepositoryError> {
        let transaction = fetchTransaction(by: id)
        
        switch transaction {
        case .success(let transaction):
            guard let transaction else { return .failure(.transactionNotFound) }
            
            if let amount {
                transaction.amount = amount as NSDecimalNumber
            }
            
            if let date {
                transaction.date = date
            }
            
            if let note {
                transaction.note = note
            }
            
            transaction.updatedAt = Date()
            
            do {
                try context.save()
                return .success(transaction)
            } catch {
                return .failure(.updateFailed)
            }
        case .failure(let error):
            return .failure(error)
        }
    }
}

// MARK: - Delete
extension TransactionRepository {
    func deleteTransaction(id: UUID) -> Result<Bool, TransactionRepositoryError> {
        let transaction = fetchTransaction(by: id)
        
        switch transaction {
        case .success(let transaction):
            guard let transaction else { return .failure(.transactionNotFound)}
            
            context.delete(transaction)
            
            do {
                try context.save()
                return .success(true)
            } catch {
                return .failure(.deletionFailed)
            }
        case .failure(let error):
            return .failure(error)
        }
    }
}
