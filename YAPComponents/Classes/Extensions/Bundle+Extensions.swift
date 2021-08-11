//
//  UIBundle+Extensions.swift
//  YAPKit
//
//  Created by Zain on 28/05/2020.
//  Copyright © 2020 YAP. All rights reserved.
//

import Foundation
import UIKit

// MARK: Evironments

public extension Bundle {
    enum Evironment: String {
        case develop = "Develop"
        case stage = "Stage"
        case qa = "QA"
        case production = "Production"
        case preprod = "PreProd"
        case household = "Household-Develop"
        case other = ""
    }
    
    var environment: Bundle.Evironment {
        guard let env = Bundle.main.object(forInfoDictionaryKey: "Environment") as? String else { return .other }
        return Bundle.Evironment(rawValue: env) ?? .other
    }
}
