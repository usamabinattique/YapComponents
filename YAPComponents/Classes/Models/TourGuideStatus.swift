//
//  TourGuide.swift
//  YAPKit
//
//  Created by Muhammad Hassan on 23/12/2020.
//  Copyright © 2020 YAP. All rights reserved.
//

import Foundation

public enum TourGuideView: String, Codable {
    case dashboard = "DASHBOARD_SCREEN"
    case dashboardGraph = "DASHBOARD_GRAPH_SCREEN"
    case cardsHome = "CARD_HOME_SCREEN"
    case cardDetails = "PRIMARY_CARD_DETAIL_SCREEN"
    case store = "STORE_SCREEN"
    case more = "MORE_SCREEN"
}

public struct TourGuideStatus: Codable {
    public let viewName: TourGuideView
    public let skipped: Bool
    public let completed: Bool
}


extension TourGuideStatus {
    static var mock: [TourGuideStatus] {
        return [TourGuideStatus.init(viewName: .dashboard, skipped: false, completed: false)]
    }
}
