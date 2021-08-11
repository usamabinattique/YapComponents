//
//  CompanyIncomeInformation.swift
//  YAPKit
//
//  Created by Ayesha on 25/06/2021.
//  Copyright © 2021 YAP. All rights reserved.
//

import Foundation

public struct CompanyIncomeInformation: Codable {
   public let depositSource: [String]
   public let annualTurnover: [String]
   public let monthlyTransaction: [String]
}


public extension CompanyIncomeInformation {
    static var mocked : CompanyIncomeInformation {
        return CompanyIncomeInformation(depositSource: [
                                            "Personal Account",
                                            "Another Business Account",
                                            "A client",
                                            "A supplier",
                                            "An investor"],
                                        annualTurnover: [
                                            "AED 0 - AED 2,000",
                                            "AED 2,000 - AED 10,000",
                                            "AED 10,000 - AED 50,000",
                                            "AED 50,000 - AED 100,000",
                                            "AED 100,000 and above"],
                                        monthlyTransaction: [
                                            "AED 0 - AED 2,000",
                                            "AED 2,000 - AED 10,000",
                                            "AED 10,000 - AED 50,000",
                                            "AED 50,000 - AED 100,000",
                                            "AED 100,000 and below"
                                        ])
    }
}
