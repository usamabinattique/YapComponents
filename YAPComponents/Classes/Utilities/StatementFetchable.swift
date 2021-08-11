//
//  StatementFetchable.swift
//  YAPKit
//
//  Created by Wajahat Hassan on 17/08/2020.
//  Copyright © 2020 YAP. All rights reserved.
//

import Foundation

public enum StatementType {
    case card
    case account
    case wallet
}

public protocol StatementFetchable {
    var idForStatements: String? { get }
    var statementType: StatementType { get }
}
