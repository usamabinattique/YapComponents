//
//  PublicAppDelegate.swift
//  YAPKit
//
//  Created by Wajahat Hassan on 03/07/2019.
//  Copyright © 2019 YAP. All rights reserved.
//

import Foundation
import RxSwift
public protocol PublicAppDelegate {
    func registerForPushNotifications()
    var deviceToken: Observable<String?> { get }
}
