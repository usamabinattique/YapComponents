//
//  String+Extension.swift
//  YAPComponents
//
//  Created by Sarmad on 13/09/2021.
//

import UIKit

public extension String {
    var length:Int { return (self as NSString).length }
    var range:NSRange { return NSRange(location: 0, length:self.length)}
    
    func replace(string: String, replacement: String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: String.CompareOptions.literal, range: nil)
    }
    
    func removingGroupingSeparator() -> String {
        return self.replace(string: localeNumberFormatter.currencyGroupingSeparator, replacement: "")
    }
}

public var localeNumberFormatter: NumberFormatter = {
    let numberFormatter = NumberFormatter()
    numberFormatter.locale = .current
    return numberFormatter
}()
