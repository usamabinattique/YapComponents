//
//  UIFont+Extensions.swift
//  YAPKit
//
//  Created by Zain on 17/06/2019.
//  Copyright © 2019 YAP. All rights reserved.
//

import UIKit

public enum AppTextStyle {
    case title1
    case title2
    case title3
    case large
    case regular
    case small
    case micro
    case nano
    
    var fontSize:CGFloat {
        switch self {
        case .title1:   return 28.0
        case .title2:   return 24.0
        case .title3:   return 21.0
        case .large:    return 18.0
        case .regular:  return 16.0
        case .small:    return 14.0
        case .micro:    return 12.0
        case .nano:     return 10.0
        }
    }
}

public typealias AppFontWeight = UIFont.Weight

public extension UIFont {
    
    static func appFont(for style: AppTextStyle, weight: AppFontWeight = .regular, scale:CGFloat = 1) -> UIFont {
        return .systemFont(ofSize: style.fontSize * scale, weight: weight)
    }
        
    static var title1: UIFont  { return appFont(for: .title1)  }
    static var title2: UIFont  { return appFont(for: .title2)  }
    static var title3: UIFont  { return appFont(for: .title3)  }
    static var large: UIFont   { return appFont(for: .large)   }
    static var regular: UIFont { return appFont(for: .regular) }
    static var small: UIFont   { return appFont(for: .small)   }
    static var micro: UIFont   { return appFont(for: .micro)   }
    
}

/*
extension UIFont {
    /*
    static func getDynamicFont(for style: UIFont.TextStyle,
                     name: String? = nil,
                     weight: UIFont.Weight? = nil,
                     size: CGFloat? = nil ) -> UIFont {
        var font:UIFont!
        if let name = name {
            font = UIFont.init(name: name, size: size ?? 17)
        }
        if font == nil {
            font = UIFont.systemFont(ofSize: size ?? 0)
        }
        font = UIFontMetrics(forTextStyle: style).scaledFont(for: font)
        //if let weight = weight {
        //    font = UIFont.systemFont(ofSize: font.pointSize, weight: weight)
        //}
        return font!
    } */
    
    static func getDynamicFont(for style: UIFont.TextStyle,
                     weight: UIFont.Weight? = nil,
                     size: CGFloat? = nil ) -> UIFont {

        if font == nil {
            font = UIFont.systemFont(ofSize: size ?? 0)
        }
        //font = UIFontMetrics(forTextStyle: style).scaledFont(for: font)
        
        if let weight = weight {
            font = UIFont.systemFont(ofSize: font.pointSize, weight: weight)
        }
        return font!
    }
}


extension UIFont {
    
    func with(weight: UIFont.Weight) -> UIFont {
        return UIFont.systemFont(ofSize: pointSize, weight: weight)
    }
    
    static func dynamic(_ style:UIFont.TextStyle,
                         weight:UIFont.Weight? = nil,
                         size:Int? = nil) -> UIFont {
        var font = SharedManager.getFontOfSize(size: Int(size ?? style.fontSize))
        let fontMetrics = UIFontMetrics(forTextStyle: style)
        font = fontMetrics.scaledFont(for: font)
        if let fweight = weight {
            font = font.with(weight: fweight)
        }
        return font
    }
    
    static func dynamic(_ font:UIFont,
                        style:UIFont.TextStyle,
                        weight:UIFont.Weight? = nil,
                        size:Int? = nil) -> UIFont {
        var font = font
        let fontMetrics = UIFontMetrics(forTextStyle: style)
        font = fontMetrics.scaledFont(for: font)
        if let fweight = weight {
            font = font.with(weight: fweight)
        }
        return font
    }
}
*/
