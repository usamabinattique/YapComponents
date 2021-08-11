//
//  ToureGuideUserDefaults.swift
//  YAPKit
//
//  Created by Wajahat Hassan on 10/12/2020.
//  Copyright © 2020 YAP. All rights reserved.
//

import Foundation
import RxSwift

public enum TourGuideUserDefaultKeys: String, CaseIterable, Codable {
    case home
    case homeGraph
    case homeCard
    case cardDetails
    case store
    case more
}

public class TourGuideUserDefaults {
    
    private init() { }
    
    public static let shared = TourGuideUserDefaults()
    
    public func setTourGuidePrompt(key: TourGuideUserDefaultKeys) {
        UserDefaultsHelper.setData(value: true, key: key.rawValue)
    }
    
    public func isTourGuidePrompted(key: TourGuideUserDefaultKeys) -> Bool {
        UserDefaultsHelper.getData(type: Bool.self, forkey: key.rawValue) ?? false
    }
    
    public func removeTourGuideData(key: TourGuideUserDefaultKeys){
        UserDefaultsHelper.removeData(key: key.rawValue)
    }
    
    public func removeAllTourGuideData() {
        _ = TourGuideUserDefaultKeys.allCases.map({ UserDefaultsHelper.removeData(key: $0.rawValue)})
    }
}
