//
//  AppCurrency.swift
//  MindBudget
//
//  Created by Vadim Kononenko on 16.09.2025.
//

import Foundation

enum AppCurrency: String, CaseIterable, Codable {
    case uah = "UAH"
    case usd = "USD"
    case eur = "EUR"
    
    var symbol: String {
        switch self {
        case .uah: return "₴"
        case .usd: return "$"
        case .eur: return "€"
        }
    }
    
    var displayName: String {
        switch self {
        case .uah: return "Hryvnia"
        case .usd: return "Dollar (USA)"
        case .eur: return "EURO"
        }
    }
    
    // TODO: Modify Via Using Currency API
    var exchangeRateToUAH: Decimal {
        switch self {
        case .uah: return 1.0
        case .usd: return 37.0
        case .eur: return 40.0
        }
    }
}
