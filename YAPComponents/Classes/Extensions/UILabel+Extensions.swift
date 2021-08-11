//
//  UILabel+Extensions.swift
//  YAPKit
//
//  Created by Zain on 30/08/2019.
//  Copyright © 2019 YAP. All rights reserved.
//

import Foundation

public extension UILabel {
    var textSize: CGSize {
        guard let text = self.text else { return .zero }
        return (text as NSString).size(withAttributes: [.font: font ?? UIFont.systemFont(ofSize: 12)])
    }
    
    func textSize(constrainedToWidth width: CGFloat) -> CGSize {
        guard let text = self.text else { return .zero }
        
        return (text as NSString).boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: [.font: font ?? UIFont.regular], context: nil).size
    }
    
    func textSize(constrainedToHeight height: CGFloat) -> CGSize {
        guard let text = self.text else { return .zero }
        
        return (text as NSString).boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: height), options: .usesLineFragmentOrigin, attributes: [.font: font ?? UIFont.regular], context: nil).size
    }
}
