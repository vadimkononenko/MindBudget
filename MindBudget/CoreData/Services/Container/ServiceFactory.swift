//
//  ServiceFactory.swift
//  MindBudget
//
//  Created by Vadim Kononenko on 23.09.2025.
//

import Foundation

class ServiceFactory {
    static func createServices() -> ServiceContaining {
        return ServiceContainer(
            coreDataManager: CoreDataManager.shared,
            usePreview: false
        )
    }

    static func createPreviewServices() -> ServiceContaining {
        return ServiceContainer(
            coreDataManager: CoreDataManager.preview,
            usePreview: true
        )
    }
}
