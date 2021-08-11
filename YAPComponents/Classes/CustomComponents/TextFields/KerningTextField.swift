//
//  KerningTextField.swift
//  YAPKit
//
//  Created by Janbaz Ali on 09/10/2020.
//  Copyright © 2020 YAP. All rights reserved.
//

import Foundation
class KerningTextField : AppTextField {
    
    @IBInspectable var kerningValue : CGFloat = 10.0 {
        didSet {
            self.configureAttributedText()
        }
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        didLoad()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        didLoad()
    }
    
    override public var text: String? {
        didSet {
            self.configureAttributedText()
        }
    }
    
    func didLoad() {
        self.addTarget(self, action: #selector(KerningTextField.configureAttributedText as (KerningTextField) -> () -> ()), for: .editingChanged)
        
        self.addTarget(self, action: #selector(KerningTextField.configureAttributedText as (KerningTextField) -> () -> ()), for: .valueChanged)
    }
    
    @objc func configureAttributedText () {
        let text: String = self.attributedText?.string ?? self.text ?? ""
//        let fontSize = self.font?.pointSize ?? 13.0
//        let fontName = self.font?.fontName ?? UIFont.systemFont(ofSize: fontSize).fontName
//        let fontColor = self.textColor ?? UIColor.black
//
       // let font = UIFont(name: fontName, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
        
        let attributedText =  NSAttributedString(string: text, attributes: [NSAttributedString.Key.kern:self.kerningValue])
        
       
        
        self.attributedText = attributedText
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
}
