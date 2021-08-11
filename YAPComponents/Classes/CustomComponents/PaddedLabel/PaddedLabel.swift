//
//  PaddedLabel.swift
//  YAPKit
//
//  Created by Muhammad Hassan on 13/09/2019.
//  Copyright © 2019 YAP. All rights reserved.
//

import Foundation

public class PaddedLabel: UILabel {
    
    public var topInset: CGFloat = 5.0
    public var bottomInset: CGFloat = 5.0
    public var leftInset: CGFloat = 7.0
    public var rightInset: CGFloat = 7.0
    
    public var edgeInset: CGFloat = 0 {
        didSet {
            topInset = edgeInset
            bottomInset = edgeInset
            leftInset = edgeInset
            rightInset = edgeInset
        }
    }
    
    public override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
    
    public override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }
    
    public override func sizeToFit() {
        super.sizeThatFits(intrinsicContentSize)
    }
}
