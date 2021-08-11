//
//  Transactions.swift
//  YAPKit
//
//  Created by Wajahat Hassan on 27/08/2019.
//  Copyright © 2019 YAP. All rights reserved.
//

import Foundation
import RxDataSources

public struct BarGraphTransaction: Codable {
    public let date: String
    public let totalAmount: String
    public let closingBalance: String
    public let amountPercentage: Double
    public let totalAmountType: TransactionType
    public let transactionItems: [TransactionItem]
}

public extension BarGraphTransaction {
    var formattedClosingBalance: String {
        let balance = Double(closingBalance) ?? 0
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        // TODO: Show curreny dynamically once API is integrated
        return "AED " + (formatter.string(from: NSNumber(value: balance)) ?? "0.00")
    }
}

public struct SectionTransaction: Codable {
    public let date: Date
    public let totalAmount: Double
    public let closingBalance: Double
    public let totalAmountType: TransactionType
    public let transactions: [TransactionResponse]
    
    public init(day: Date, transactions: [TransactionResponse]) {
        self.date = day
        self.transactions = transactions
        self.totalAmount = transactions.reduce(0, { $1.type == .debit ? $0 - $1.amount : $0 + $1.amount })
        self.closingBalance = transactions.last?.closingBalance ?? 0
        self.totalAmountType = totalAmount > 0 ? .credit : .debit
    }
    
    public init(day: Date, amount: Double, closingBalance: Double) {
        self.date = day
        self.totalAmount = amount
        self.closingBalance = closingBalance
        self.totalAmountType = totalAmount > 0 ? .credit : .debit
        self.transactions = []
    }
}

extension SectionTransaction {
    var formattedClosingBalance: String {
        CurrencyFormatter.formatAmountInLocalCurrency(closingBalance)
    }
    
    var isNoTransactionToday: Bool {
        return transactions.count == 0
    }
    
    var formattedDate: String? {
        return DateFormatter.graphDateFormatter.string(from: date)
    }
    
    var formattedMonthDate: String? {
        return DateFormatter.graphMonthDateFormatter.string(from: date)
    }
    
    func amountPercentage(withRespectTo maxAmount: Double) -> Double {
        guard maxAmount != 0 else { return 1 }
        return (abs(closingBalance) / maxAmount)
    }
}

extension SectionTransaction: Equatable {
    public static func == (lhs: SectionTransaction, rhs: SectionTransaction) -> Bool {
        return lhs.date == rhs.date && lhs.closingBalance == rhs.closingBalance && lhs.totalAmount == rhs.totalAmount && lhs.totalAmountType == rhs.totalAmountType && lhs.transactions == rhs.transactions
    }
}
