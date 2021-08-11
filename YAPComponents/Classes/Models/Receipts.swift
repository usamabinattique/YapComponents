//
//  Receipts.swift
//  YAPKit
//
//  Created by Wajahat Hassan on 11/02/2021.
//  Copyright © 2021 YAP. All rights reserved.
//

import Foundation
public struct Receipts: Codable {
    public let receiptList: [String]?
    
    enum CodingKeys: String, CodingKey {
        case receiptList = "trxnReceiptList"
    }
}
