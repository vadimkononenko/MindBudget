//
//  ServiceContainer.swift
//  MindBudget
//
//  Created by Vadim Kononenko on 23.09.2025.
//

import Foundation
import CoreData

class ServiceContainer {
    private let coreDataManager: CoreDataManager
    private let usePreview: Bool
    
    init(
        coreDataManager: CoreDataManager = CoreDataManager.shared,
        usePreview: Bool = false
    ) {
        self.coreDataManager = coreDataManager
        self.usePreview = usePreview
    }
    
    private var context: NSManagedObjectContext {
        usePreview ? coreDataManager.previewContext : coreDataManager.viewContext
    }
    
    lazy var budgetService: BudgetServiceProtocol = {
        BudgetService(context: context)
    }()
    
    lazy var transactionService: TransactionServiceProtocol = {
        TransactionService(context: context)
    }()
    
    lazy var categoryService: CategoryServiceProtocol = {
        CategoryService(context: context)
    }()
    
    lazy var goalService: FinancialGoalServiceProtocol = {
        FinancialGoalService(context: context)
    }()
    
    lazy var tagService: TagServiceProtocol = {
        TagService(context: context)
    }()
}
