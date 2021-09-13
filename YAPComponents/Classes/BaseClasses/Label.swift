//
//  Label.swift
//  iOSApp
//
//  Created by Abbas on 07/06/2021.
//

import UIKit

public class Label: UILabel {

    var textInsets = UIEdgeInsets.zero {
        didSet { invalidateIntrinsicContentSize() }
    }
    
    public override var text: String? {
        set {
            if spacing == nil && self.lineSpacing == nil {
                super.text  = newValue
            } else {
                self.setAttributedText(newValue ?? "")
            }
        }
        get {
            return super.attributedText?.string ?? super.text
        }
    }
    
    var spacing:Float? = nil { didSet {
        
    }}
    
    var lineSpacing:CGFloat? = nil { didSet {
        
    }}

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        makeUI()
    }

    func makeUI() {
        layer.masksToBounds = true
        numberOfLines = 1
        updateUI()
    }

    func updateUI() {
        setNeedsDisplay()
    }
}

public extension Label {
    
    @discardableResult func setInsets(_ insets:UIEdgeInsets) -> Self {
        textInsets = insets
        return self
    }

    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insetRect = bounds.inset(by: textInsets)
        let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
        let invertedInsets = UIEdgeInsets(top: -textInsets.top,
                                          left: -textInsets.left,
                                          bottom: -textInsets.bottom,
                                          right: -textInsets.right)
        return textRect.inset(by: invertedInsets)
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }

    var leftTextInset: CGFloat {
        get { return textInsets.left }
        set { textInsets.left = newValue }
    }

    var rightTextInset: CGFloat {
        get { return textInsets.right }
        set { textInsets.right = newValue }
    }

    var topTextInset: CGFloat {
        get { return textInsets.top }
        set { textInsets.top = newValue }
    }

    var bottomTextInset: CGFloat {
        get { return textInsets.bottom }
        set { textInsets.bottom = newValue }
    }
}

extension Label {
    fileprivate func setAttributedText(_ string:String) {
        let attributedString = NSMutableAttributedString(string: string, attributes: [.font:font!, .foregroundColor:textColor!])
        if let spacing = spacing {
            attributedString.addAttributes([.kern : spacing], range: string.range )
        }
        
        if let lineSpacing = lineSpacing {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = lineSpacing
            attributedString.addAttributes([.paragraphStyle : paragraphStyle, .font:font!, .foregroundColor:textColor!], range: string.range )
        }
        attributedText = attributedString
    }
}
