//
//  ServiceContainer.swift
//  MindBudget
//
//  Created by Vadim Kononenko on 23.09.2025.
//

import Foundation

class ServiceContainer {
    private let coreDataManager: CoreDataManager
    
    init(coreDataManager: CoreDataManager = CoreDataManager.shared) {
        self.coreDataManager = coreDataManager
    }
    
    lazy var budgetService: BudgetServiceProtocol = {
        BudgetService(context: coreDataManager.viewContext)
    }()
    
    lazy var transactionService: TransactionServiceProtocol = {
        TransactionService(context: coreDataManager.viewContext)
    }()
    
    lazy var categoryService: CategoryServiceProtocol = {
        CategoryService(context: coreDataManager.viewContext)
    }()
    
    lazy var goalService: FinancialGoalServiceProtocol = {
        FinancialGoalService(context: coreDataManager.viewContext)
    }()
    
    lazy var tagService: TagServiceProtocol = {
        TagService(context: coreDataManager.viewContext)
    }()
}
