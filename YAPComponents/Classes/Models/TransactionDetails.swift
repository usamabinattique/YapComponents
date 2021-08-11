//
//  TransactionDetails.swift
//  YAPKit
//
//  Created by Wajahat Hassan on 29/10/2019.
//  Copyright © 2019 YAP. All rights reserved.
//

import Foundation

public struct TransactionDetails: Codable {
    public let date: Date
    public let amount: Double
    public let totalAmount: Double
    public let feeAmount: Double?
    public var title: String?
    public let transactionId: String
    public let transactionNote: String?
    public let type: TransactionType
    public let productCode: TransactionProductCode?
    public let senderName: String?
    public let receiverName: String?
    public let currencySymbol: String?
    public let vat: Double?
    public let postedFees: Double?
    
    public var sectionDate: Date {
        var dateComponents = DateComponents()
        let dateComponents2 = Calendar.current.dateComponents([.day, .month, .year], from: date)
        dateComponents.calendar = Calendar.current
        dateComponents.year = dateComponents2.year
        dateComponents.month = dateComponents2.month
        dateComponents.day = dateComponents2.day
        return dateComponents.date!
    }
    
    public var time: String {
        let timeFormatter = DateFormatter()
        timeFormatter.timeZone = TimeZone(abbreviation: "UTC")
        timeFormatter.dateFormat = "HH:mm a"
        timeFormatter.amSymbol = "am"
        timeFormatter.pmSymbol = "pm"
        return timeFormatter.string(from: date)
    }
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case amount = "amount"
        case date = "creationDate"
        case feeAmount = "feeAmount"
        case totalAmount = "totalAmount"
        case transactionId = "transactionId"
        case transactionNote = "transactionNote"
        case type = "txnType"
        case productCode = "productCode"
        case senderName = "senderName"
        case receiverName = "receiverName"
        case currencySymbol = "currency"
        case postedFees = "postedFees"
        case vat = "vat"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try? container.decode(String?.self, forKey: .title)
        amount = try container.decode(Double.self, forKey: .amount)
        feeAmount = try? container.decode(Double?.self, forKey: .feeAmount)
        postedFees = try? container.decode(Double?.self, forKey: .postedFees)
        totalAmount = try container.decode(Double.self, forKey: .totalAmount)
        transactionNote = try? container.decode(String?.self, forKey: .transactionNote)
        let dateString = try container.decode(String.self, forKey: .date)
        self.date = DateFormatter.transactionDateFormatter.date(from: dateString) ?? Date()
        transactionId = try container.decode(String.self, forKey: .transactionId)
        type = try container.decode(TransactionType.self, forKey: .type)
        productCode = try? container.decode(TransactionProductCode?.self, forKey: .productCode)
        senderName = try? container.decode(String?.self, forKey: .senderName)
        receiverName = try? container.decode(String?.self, forKey: .receiverName)
        currencySymbol = try? container.decode(String?.self, forKey: .currencySymbol)
        let vatValue = try? container.decode(Double.self, forKey: .vat)
        vat = vatValue != nil ? vatValue : 0.0
    }
    
    
    
}
