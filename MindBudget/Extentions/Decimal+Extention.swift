//
//  Decimal+Extention.swift
//  MindBudget
//
//  Created by Vadim Kononenko on 24.09.2025.
//

import Foundation

extension Decimal {
    func toDouble() -> Double {
        return NSDecimalNumber(decimal: self).doubleValue
    }
}
