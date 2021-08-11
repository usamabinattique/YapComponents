//
//  HouseholdPayNow.swift
//  YAPKit
//
//  Created by Muhammad Awais on 20/05/2020.
//  Copyright © 2020 YAP. All rights reserved.
//

import Foundation

public struct HouseholdPayNow: Codable {
    public let transactionId: String
}

//MARK: - Mocked
public extension HouseholdPayNow {
    static var mocked: HouseholdPayNow = HouseholdPayNow(transactionId: "00001X")
}
