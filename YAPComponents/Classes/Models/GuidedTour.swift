//
//  GuidedTour.swift
//  YAP
//
//  Created by Muhammad Awais on 17/03/2020.
//  Copyright © 2020 YAP. All rights reserved.
//

import Foundation
import UIKit

public enum drawType {
    case circle
    case rectangle
}

public struct GuidedTour {
    var title: String?
    var tourDescription: String?
    var buttonTitle: String?
    var circle: GuidedCircle?
    public init(title: String?, tourDescription: String?, buttonTitle: String? = "Next", circle: GuidedCircle, type: drawType = .circle){
        self.title = title
        self.tourDescription = tourDescription
        self.circle = circle
        self.buttonTitle = buttonTitle
    }
}

public struct GuidedCircle {
    var centerPointX: Int?
    var centerPointY: Int?
    var radius: Int?
    var viewType: drawType?
    
    public init(centerPointX: Int, centerPointY: Int, radius: Int, viewType: drawType = .circle) {
        self.centerPointX = centerPointX
        self.centerPointY = centerPointY
        self.radius = radius
        self.viewType = viewType
    }
}

extension GuidedTour {
    public static var mocked: [GuidedTour] {
        return [GuidedTour(title: "Daily transaction chart", tourDescription: "Here you can see your daily spending in chart-like way. You can drag your finger to see specific date.", circle: GuidedCircle(centerPointX: 188, centerPointY: 220, radius: 75)),
                GuidedTour(title: "Your current balance", tourDescription: "Here you can see your account’s current balance. It will be updated in-real time after every transaction.", circle: GuidedCircle(centerPointX: 188, centerPointY: 80, radius: 75)),
                GuidedTour(title: "Search", tourDescription: "Click here to search for specific transaction in your account history", circle: GuidedCircle(centerPointX: 35, centerPointY: 40, radius: 75)),
                GuidedTour(title: "YAP it", tourDescription: "Click here to see more actions like: YAP to YAP transactions,  yop up your account, send money and pay your bills", circle: GuidedCircle(centerPointX: 188, centerPointY: 630, radius: 50)), GuidedTour(title: "Menu bar", tourDescription: "Click here to view the menu bar where you can see your account details and navigate to useful pages", circle: GuidedCircle(centerPointX: 400, centerPointY: 50, radius: 40))]
    }
}
