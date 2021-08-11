//
//  InAppNotification.swift
//  YAPKit
//
//  Created by Zain on 30/12/2020.
//  Copyright © 2020 YAP. All rights reserved.
//

import Foundation

public enum InAppNotificationType {
    case operational
    case transactional
    case marketing
}

public enum InAppNotificationAction {
    case completeVerification
    case setPin
    case updateEmiratesId
    case householdInvitation
    case helpAndSupport
    case callHelpLine
    case none
}

public extension InAppNotificationAction {
    var actionTitle: String? {
        switch self {
        case .completeVerification:
            return "Complete verification"
        case .setPin:
            return "Set PIN now"
        case .updateEmiratesId:
            return "Scan Emirates ID"
        case .householdInvitation:
            return "Accept invitations"
        case .helpAndSupport:
            return "Open Help & Support"
        case .callHelpLine:
            return "Call us"
        case .none:
            return nil
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .helpAndSupport, .callHelpLine:
            return UIImage.sharedImage(named: "icon_notification_general")
        case .completeVerification, .updateEmiratesId:
            return UIImage.sharedImage(named: "icon_notification_documents")
        case .setPin:
            return UIImage.sharedImage(named: "icon_notification_setpin")
        default:
            return UIImage.sharedImage(named: "icon_notification_general")
        }
    }
}

public struct InAppNotification {
    public let id: String?
    public let title: String?
    public let description: String?
    public let deletable: Bool
    public let date: Date?
    public let imageUrl: String?
    public let readStatus: Bool
    public let action: InAppNotificationAction?
    public let notificationType: InAppNotificationType
}

public extension InAppNotification {
    init(notification: TransactionNotification) {
        self.id = notification.notificationId
        self.title = notification.title
        self.description = notification.notificationText
        self.deletable = notification.isDeleteable
        self.date = DateFormatter.serverReadableDateFromatter.date(from: notification.transactionDate ?? "")
        self.imageUrl = notification.profilePicUrl
        self.readStatus = notification.isRead
        self.action = InAppNotificationAction.none
        self.notificationType = .transactional
    }
    
}

public extension InAppNotification {
    var imageWithUrl: ImageWithURL {
        (imageUrl, title?.initialsImage(color: .primary))
    }
    
    var userReadableDate: String? {
        date?.userReadableDateString
    }
}

extension InAppNotification: Comparable {
    public static func < (lhs: InAppNotification, rhs: InAppNotification) -> Bool {
        
        if let lDate = lhs.date , let rDate =  rhs.date , lDate < rDate {
            return true
        } else { return false }
    }
}
