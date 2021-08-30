//
//  CoreFoundation+Extension.swift
//  iOSApp
//
//  Created by Abbas on 06/06/2021.
//

import UIKit

public extension String {
    var trimmed: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var intValue: Int {
        return (self as NSString).integerValue
    }
    var doubleValue:Double {
        return (self as NSString).doubleValue
    }
    var cgfloatValue:CGFloat {
        return CGFloat((self as NSString).doubleValue)
    }
    var boolValue:Bool {
        return (self as NSString).boolValue
    }
}

public extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}

