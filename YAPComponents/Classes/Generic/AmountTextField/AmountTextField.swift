//
//  AmountTextField.swift
//  YAPKit
//
//  Created by Wajahat Hassan on 08/04/2020.
//  Copyright © 2020 YAP. All rights reserved.
//

import Foundation
public class AmountTextField: UITextField {
    
    public var appFont: UIFont = .title3
    
    // MARK: Views
    public lazy var formattedLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = textColor
        label.textAlignment = textAlignment
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: Properties
    fileprivate lazy var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits =  2
        formatter.minimumFractionDigits =  2
        return formatter
    }()
    
    public var numberOfFractionDigits: Int = 2 {
        didSet {
            numberFormatter.minimumFractionDigits = numberOfFractionDigits
            numberFormatter.maximumFractionDigits = numberOfFractionDigits
        }
    }
    
    public override var textColor: UIColor? {
        didSet {
            guard textColor != .clear else { return }
            _textColor = textColor
            textColor = .clear
        }
    }
    
    fileprivate var _textColor: UIColor? = .clear
    
    
    public var placeholderColor: UIColor = UIColor.greyDark {
        didSet {
            let placeholder = self.placeholder
            self.placeholder = placeholder
        }
    }
    
    public override var placeholder: String? {
        didSet {
            guard  let `placeholder` = placeholder else { return }
            let attributedPlaceholder = NSMutableAttributedString(string: placeholder)
            attributedPlaceholder.addAttributes([.foregroundColor: self.placeholderColor], range: NSRange(location: 0, length: placeholder.count))
            self.attributedPlaceholder = attributedPlaceholder
        }
    }
    
    open override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return rect(forBounds: bounds)
    }
    
    private func rect(forBounds bounds: CGRect) -> CGRect {
        
        return CGRect(x: bounds.origin.x, y: bounds.origin.y, width: bounds.size.width, height: bounds.size.height) 
        
    }
    
    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    public convenience init (alignment: NSTextAlignment, font: UIFont) {
        self.init()
        textAlignment = alignment
        formattedLabel.textAlignment = alignment
        appFont = font
        self.font = appFont
        formattedLabel.font = appFont
    }
    
    private func commonInit() {
        font = appFont
        textAlignment = .center
        formattedLabel.font = appFont
        addSubview(formattedLabel)
        constraints()
        addTarget(self, action: #selector(editted), for: .allEditingEvents)
        _textColor = textColor
        
    }
    
    // MARK: View cycle
    public override func draw(_ rect: CGRect) {
        formattedLabel.frame = rect
        formattedLabel.alignEdgesWithSuperview([.left, .right, .bottom, .top], constants: [0, 0, 0, 0])
    }
    
    public override func editingRect(forBounds bounds: CGRect) -> CGRect {
        
        guard textAlignment != .left else { return bounds }
        var rect = bounds
        let diff = (formattedLabel.text?.width(for: font, constrainedTo: bounds.height) ?? 0) - (text?.width(for: font, constrainedTo: bounds.height) ?? 0)
        
        if textAlignment == .center { rect.origin.x -= diff/2 }
        
        if textAlignment == .right { rect.origin.x -= diff }
        
        return rect
        
    }
    
    func constraints() { alignAllEdgesWithSuperview() }
    
    // MARK: Private methods
    
    @objc func editted() {
        
        if (text ?? "" ).isEmpty && !(placeholder ?? "").isEmpty {
            self.text = ""
            self.formattedLabel.attributedText = NSAttributedString.init(string: "")
            return
        }
        
        textColor = .clear
        var `text` = self.text ?? ""
        text = text.replacingOccurrences(of: ",", with: "")
        
        if text.contains(".") {
            let fractions = (text.count - 1) - (text as NSString).range(of: ".").location
            if fractions > numberOfFractionDigits {
                text.removeLast(fractions - numberOfFractionDigits)
            }
            
        }
        
        let doubleValue = Double(text) ?? 0
        let formattedText = numberFormatter.string(from: NSNumber(value: doubleValue)) ?? ""
        let attributed = NSMutableAttributedString(string: formattedText)
        attributed.addAttributes([.foregroundColor: _textColor ?? .black], range: NSRange(location: 0, length: formattedText.count))
        var textToAppend = formattedText
        if text.contains(".") {
            let fractions = (text.count - 1) - (text as NSString).range(of: ".").location
            textToAppend.removeLast(numberOfFractionDigits - fractions)
            
        } else {
            textToAppend.removeLast(numberOfFractionDigits + 1)
            if text.isEmpty { textToAppend.removeLast(1) }
        }
        
        self.text = textToAppend
        
        guard let grayRange = grayRange(for: text, formattedText: formattedText) else {
            self.formattedLabel.attributedText = attributed
            return
        }
        
        attributed.addAttributes([.foregroundColor: UIColor.lightGray], range: grayRange)
        self.formattedLabel.attributedText = attributed
        
    }
    
}

// MARK: Private methods

private extension AmountTextField {
    
    func grayRange(for text: String, formattedText: String) -> NSRange? {
        guard !text.isEmpty else { return NSRange(location: 0, length: formattedText.count) }
        guard text.contains(".") else { return NSRange(location: formattedText.count - (numberOfFractionDigits + 1), length: numberOfFractionDigits + 1) }
        let fractions = (text.count - 1) - (text as NSString).range(of: ".").location
        guard fractions < numberOfFractionDigits else { return nil }
        return NSRange(location: formattedText.count - (numberOfFractionDigits - fractions), length: numberOfFractionDigits - fractions)
        
    }
}

fileprivate extension String {
    
    func width(for font: UIFont?, constrainedTo height: CGFloat) -> CGFloat {
        (self as NSString) .boundingRect(with: CGSize(width: .greatestFiniteMagnitude, height: height), options: .usesLineFragmentOrigin, attributes: [.font : font!], context: nil)
            .width
    }
    
}


extension AmountTextField: UITextFieldDelegate {
    override public func closestPosition(to point: CGPoint) -> UITextPosition? {
        let beginning = self.beginningOfDocument
        let end = self.position(from: beginning, offset: self.text?.count ?? 0)
        return end
    }
}
