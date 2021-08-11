//
//  NotificationName+Extensions.swift
//  YAPKit
//
//  Created by Zain on 14/02/2020.
//  Copyright © 2020 YAP. All rights reserved.
//

import Foundation

public extension Notification.Name {
    static let ApplicationWillResignActive = Notification.Name("applicationWillResignActive")
    static let ApplicationDidBecomeActive = Notification.Name("applicationDidBecomeActive")
    static let ApplicationWillEnterForeground = Notification.Name("applicationWillEnterForeground")
    static let logout = Notification.Name("LOGOUT_CURRENT_USER")
    static let goToDashbaord = Notification.Name("BACK_TO_DASHBOARD")
    static let checkUserNotificationPreference = Notification.Name("userNotifications")
    static let authenticationRequired = Notification.Name("authentication_required")
}
