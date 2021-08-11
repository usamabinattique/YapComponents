//
//  Statement.swift
//  YAPKit
//
//  Created by Wajahat Hassan on 17/08/2020.
//  Copyright © 2020 YAP. All rights reserved.
//

import Foundation

fileprivate var statementDateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMMM yyyy"
    return formatter
}

public struct Statement: Codable {
    let month: String
    let year: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case month = "month"
        case year = "year"
        case url = "statementURL"
    }
}

// MARK: - Mocked extension
extension Statement {
    public static var mocked: Statement {
        return Statement(month: "05", year: "2020", url: "")
    }

}

extension Statement {
    var date: Date {
        statementDateFormatter.date(from: [month, year].joined(separator: " ")) ?? Date()
    }
}
