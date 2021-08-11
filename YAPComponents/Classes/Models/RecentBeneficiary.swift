//
//  RecentBeneficiary.swift
//  YAPKit
//
//  Created by Zain on 03/11/2020.
//  Copyright © 2020 YAP. All rights reserved.
//

import Foundation
import UIKit

public enum RecentBeneficiaryPackage {
    case prime
    case gold
    case metal
    case none
}

public extension RecentBeneficiaryPackage {
    var image: UIImage? {
        switch self {
        case .prime:
            return UIImage.init(named: "icon_primary_badge", in: yapKitBundle, compatibleWith: nil)
        case .gold:
            return UIImage.init(named: "icon_gold_badge", in: yapKitBundle, compatibleWith: nil)
        case .metal:
            return UIImage.init(named: "icon_black_badge", in: yapKitBundle, compatibleWith: nil)
        case .none:
            return nil
        }
    }
}

public protocol RecentBeneficiaryType {
    var beneficiaryCountryCode: String? { get }
    var beneficiaryImage: ImageWithURL { get }
    var beneficiaryPackage: RecentBeneficiaryPackage { get }
    var beneficiaryTitle: String? { get }
    var beneficiarySubTitle: String? { get }
    var beneficiaryLasTransferDate: Date { get }
    func indexed(_ index: Int) -> RecentBeneficiaryType
}

public extension RecentBeneficiaryType {
    var beneficiaryPackage: RecentBeneficiaryPackage { .none }
    var beneficiaryCountryCode: String? { nil }
}

public extension Array where Element == RecentBeneficiaryType {
    var indexed: [RecentBeneficiaryType] {
        enumerated().map{ $0.1.indexed($0.0) }
    }
}

public enum SearchableBeneficiaryTransferType {
    case y2y
    case domestic
    case uaefts
    case cashPayout
    case swift
    case rmt
}

public protocol SearchableBeneficiaryType {
    var searchableTitle: String? { get }
    var searchableSubTitle: String? { get }
    var searchableIcon: ImageWithURL { get }
    var searchableIndicator: UIImage? { get }
    var searchableTransferType: SearchableBeneficiaryTransferType { get }
    func indexed(_ index: Int) -> SearchableBeneficiaryType
}

public extension Array where Element == SearchableBeneficiaryType {
    var indexed: [SearchableBeneficiaryType] {
        enumerated().map{ $0.1.indexed($0.0) }
    }
}
