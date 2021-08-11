//
//  Transaction.swift
//  YAPKit
//
//  Created by Wajahat Hassan on 27/08/2019.
//  Copyright © 2019 YAP. All rights reserved.
//

import Foundation

public struct TransactionItem: Codable {
    public let vendor: String
    public let type: TransactionType
    public let imageUrl: String
    public let time: String
    public let category: String
    public let amount: String
    public let currency: String
}
