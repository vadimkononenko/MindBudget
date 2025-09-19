//
//  AppCurrency.swift
//  MindBudget
//
//  Created by Vadim Kononenko on 16.09.2025.
//

import Foundation

enum AppCurrency: String, CaseIterable, Codable {
    case usd = "USD"
    case eur = "EUR"
    case gbp = "GBP"
    case jpy = "JPY"
    case cad = "CAD"
    case aud = "AUD"
    case chf = "CHF"
    case cny = "CNY"
    case uah = "UAH"
    case pln = "PLN"
    case sek = "SEK"
    case nok = "NOK"
    case dkk = "DKK"
    case czk = "CZK"
    case huf = "HUF"
    case ron = "RON"
    case bgn = "BGN"
    case hrk = "HRK"
    case try_ = "TRY"
    case brl = "BRL"
    case mxn = "MXN"
    case ars = "ARS"
    case clp = "CLP"
    case cop = "COP"
    case pen = "PEN"
    case inr = "INR"
    case krw = "KRW"
    case thb = "THB"
    case vnd = "VND"
    case idr = "IDR"
    case myr = "MYR"
    case sgd = "SGD"
    case php = "PHP"
    case nzd = "NZD"
    case zar = "ZAR"
    
    var symbol: String {
        switch self {
        case .usd: return "$"
        case .eur: return "€"
        case .gbp: return "£"
        case .jpy: return "¥"
        case .cad: return "C$"
        case .aud: return "A$"
        case .chf: return "CHF"
        case .cny: return "¥"
        case .uah: return "₴"
        case .pln: return "zł"
        case .sek: return "kr"
        case .nok: return "kr"
        case .dkk: return "kr"
        case .czk: return "Kč"
        case .huf: return "Ft"
        case .ron: return "lei"
        case .bgn: return "лв"
        case .hrk: return "kn"
        case .try_: return "₺"
        case .brl: return "R$"
        case .mxn: return "$"
        case .ars: return "$"
        case .clp: return "$"
        case .cop: return "$"
        case .pen: return "S/"
        case .inr: return "₹"
        case .krw: return "₩"
        case .thb: return "฿"
        case .vnd: return "₫"
        case .idr: return "Rp"
        case .myr: return "RM"
        case .sgd: return "S$"
        case .php: return "₱"
        case .nzd: return "NZ$"
        case .zar: return "R"
        }
    }
    
    var displayName: String {
        return "\(rawValue) (\(symbol))"
    }
    
    static var allTuples: [(String, String)] {
        return allCases.map { ($0.rawValue, $0.symbol) }
    }
}
