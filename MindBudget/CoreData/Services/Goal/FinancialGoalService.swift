//
//  FinancialGoalService.swift
//  MindBudget
//
//  Created by Vadim Kononenko on 23.09.2025.
//

import Foundation

protocol FinancialGoalServiceProtocol {
    func createGoal(
        name: String,
        targetAmount: Decimal,
        targetDate: Date,
        category: Category?,
        priority: Int16,
        note: String?
    ) throws -> FinancialGoal
    func fetchActiveGoals() -> [FinancialGoal]
    func updateGoalProgress(_ goal: FinancialGoal) throws -> Bool
    func markGoalAsFinished(_ goal: FinancialGoal) throws -> Bool
}

class FinancialGoalService: BaseService, FinancialGoalServiceProtocol {
    func createGoal(
        name: String,
        targetAmount: Decimal,
        targetDate: Date,
        category: Category?,
        priority: Int16,
        note: String?
    ) throws -> FinancialGoal {
        let goal = FinancialGoal(context: context)
        goal.id = UUID()
        goal.name = name
        goal.targetAmount = targetAmount as NSDecimalNumber
        goal.targetDate = targetDate
        goal.category = category
        goal.priority = priority
        goal.note = note
        goal.isFinished = false
        goal.startDate = Date()
        goal.createdAt = Date()
        goal.updatedAt = Date()
            
        try save()
        return goal
    }
        
    func fetchActiveGoals() -> [FinancialGoal] {
        let predicate = NSPredicate(format: "isFinished == false")
        let sortDescriptor = NSSortDescriptor(keyPath: \FinancialGoal.priority, ascending: false)
        return fetch(
            entityType: FinancialGoal.self,
            predicate: predicate,
            sortDescriptors: [sortDescriptor]
        )
    }
        
    func updateGoalProgress(_ goal: FinancialGoal) throws -> Bool {
        goal.updatedAt = Date()
        try save()
        return true
    }
        
    func markGoalAsFinished(_ goal: FinancialGoal) throws -> Bool {
        goal.isFinished = true
        goal.updatedAt = Date()
        try save()
        return true
    }
}
