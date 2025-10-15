//
//  ServiceContainer.swift
//  MindBudget
//
//  Created by Vadim Kononenko on 23.09.2025.
//

import Foundation
import CoreData

/// Protocol for service container to enable dependency injection and testing
protocol ServiceContaining {
    var budgetService: BudgetServiceProtocol { get }
    var transactionService: TransactionServiceProtocol { get }
    var categoryService: CategoryServiceProtocol { get }
    var goalService: FinancialGoalServiceProtocol { get }
    var tagService: TagServiceProtocol { get }
}

class ServiceContainer: ServiceContaining {
    private let context: NSManagedObjectContext

    init(coreDataManager: CoreDataManaging, usePreview: Bool = false) {
        self.context = usePreview ? coreDataManager.viewContext : coreDataManager.viewContext
    }

    // MARK: - Services

    var budgetService: BudgetServiceProtocol {
        BudgetService(context: context)
    }

    var transactionService: TransactionServiceProtocol {
        TransactionService(context: context)
    }

    var categoryService: CategoryServiceProtocol {
        CategoryService(context: context)
    }

    var goalService: FinancialGoalServiceProtocol {
        FinancialGoalService(context: context)
    }

    var tagService: TagServiceProtocol {
        TagService(context: context)
    }
}
