//
//  ServiceFactory.swift
//  MindBudget
//
//  Created by Vadim Kononenko on 23.09.2025.
//

import Foundation

class ServiceFactory {
    static func createServices() -> ServiceContainer {
        return ServiceContainer()
    }
    
    static func createPreviewServices() -> ServiceContainer {
        return ServiceContainer(
            coreDataManager: CoreDataManager.preview,
            usePreview: true
        )
    }
}
