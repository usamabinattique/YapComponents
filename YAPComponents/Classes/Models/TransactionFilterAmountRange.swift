//
//  TransactionFilterAmountRange.swift
//  YAPKit
//
//  Created by Zain on 29/10/2019.
//  Copyright © 2019 YAP. All rights reserved.
//

import Foundation

public struct TransactionFilterAmountRange: Codable {
    public let minAmount: Double
    public let maxAmount: Double
}
