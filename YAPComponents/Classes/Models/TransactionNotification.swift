//
//  TransactionNotification.swift
//  More
//
//  Created by Janbaz Ali on 21/01/2021.
//  Copyright © 2021 YAP. All rights reserved.
//

import Foundation
import UIKit

public struct TransactionNotification: Codable {
    var notificationId: String?
    var notificationType: String?
    var title: String?
    var notificationText: String?
    var profilePicUrl: String?
    var firstName: String?
    var lastName: String?
    var currency: String?
    var amount: Double?
    var transactionDate: String?
    var isRead: Bool
    var isDeleteable: Bool
    
    enum CodingKeys: String, CodingKey {
        case notificationText = "notificationTxt"
        case isRead = "read"
        case isDeleteable = "deletable"
        case notificationId, notificationType, title, profilePicUrl, firstName, lastName, currency, amount, transactionDate
    }
}
