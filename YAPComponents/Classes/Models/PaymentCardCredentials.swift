//
//  PaymentCardCredentials.swift
//  YAPKit
//
//  Created by Muhammad Hussaan Saeed on 12/09/2019.
//  Copyright © 2019 YAP. All rights reserved.
//

import Foundation

public struct PaymentCardCredentials: Codable {
    
   public let cardNumber: String
   public let cvv: String
   public let expiryDate: String
    
    enum CodingKeys: String, CodingKey {
        case cardNumber
        case cvv
        case expiryDate
    }
    
    public static var mocked: PaymentCardCredentials {
        return PaymentCardCredentials(cardNumber: "1234 1234 1234 1234", cvv: "123", expiryDate: "12/20")
    }
}

extension PaymentCardCredentials: Equatable {
    public static func == (lhs: PaymentCardCredentials, rhs: PaymentCardCredentials) -> Bool {
        return lhs.cardNumber == rhs.cardNumber && lhs.cvv == rhs.cvv && lhs.expiryDate == rhs.expiryDate
    }
}

extension PaymentCardCredentials {
    
   public var formattedCardNumber: String {
        let stride: Int = 4
        let separator: Character = " "
        return String(cardNumber.enumerated().map { $0 > 0 && $0 % stride == 0 ? [separator, $1] : [$1]}.joined())
    }
}
