//
//  MindBudgetApp.swift
//  MindBudget
//
//  Created by Vadim Kononenko on 13.09.2025.
//

import SwiftUI

@main
struct MindBudgetApp: App {
    let coreDataManager: CoreDataManager = .shared

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, coreDataManager.viewContext)
        }
    }
}

