//
//  NotificationsSetting.swift
//  YAPKit
//
//  Created by Muhammad Awais on 28/01/2021.
//  Copyright © 2021 YAP. All rights reserved.
//

import Foundation

public struct NotificationsSetting: Codable {
    public let smsEnabled: Bool
    public let inAppEnabled: Bool
    public let emailEnabled: Bool
    
    public init(sms: Bool, inApp: Bool, email: Bool) {
        self.smsEnabled = sms
        self.inAppEnabled = inApp
        self.emailEnabled = email
    }
}

