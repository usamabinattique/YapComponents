//
//  LocaleManager.swift
//  YAPKit
//
//  Created by Wajahat Hassan on 28/08/2019.
//  Copyright © 2019 YAP. All rights reserved.
//

import Foundation

open class LocaleManager: NSObject {
    public static let shared = LocaleManager()
    
    var local =  Locale(identifier: "en_AE")
    
//    public func getFormatted(balance: Double) -> String {
//        let formatter = NumberFormatter()
//        formatter.locale = local
//        formatter.numberStyle = .currency
//        if let formattedAmount = formatter.string(from: balance as NSNumber) {
//            let updateFormattedAmmountFormate = formattedAmount.replacingOccurrences(of: "AED", with: "", options: .literal, range: nil)
//            return (updateFormattedAmmountFormate)
//        }
//        return ("\(balance)")
//    }
//    
//    public func getFormatted(balance: Double, currencyDecimal: String) -> String {
//        let formatter = NumberFormatter()
//        formatter.locale = local
//        formatter.numberStyle = .currency
//        if let formattedAmount = formatter.string(from: balance as NSNumber) {
//            let updateFormattedAmmountFormate = formattedAmount.replacingOccurrences(of: currencyDecimal, with: "", options: .literal, range: nil)
//            return (currencyDecimal + " " + updateFormattedAmmountFormate)
//        }
//        return (currencyDecimal + " " + "\(balance)")
//    }
    
}
