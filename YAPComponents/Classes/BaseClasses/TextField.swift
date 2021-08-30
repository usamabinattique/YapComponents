//
//  TextField.swift
//  iOSApp
//
//  Created by Abbas on 07/06/2021.
//

import UIKit

class TextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        makeUI()
    }

    /*
    override var placeholder: String? {
        didSet {
            themeService.switch(themeService.type)
        }
    }
    */

    func makeUI() {
        /* themeService.rx
            .bind({ $0.text }, to: rx.textColor)
            .bind({ $0.secondary }, to: rx.tintColor)
            .bind({ $0.textGray }, to: rx.placeholderColor)
            .bind({ $0.text }, to: rx.borderColor)
            .bind({ $0.keyboardAppearance }, to: rx.keyboardAppearance)
            .disposed(by: rx.disposeBag) */

        translatesAutoresizingMaskIntoConstraints = false
        
        layer.masksToBounds = true
        //borderWidth = Configs.BaseDimensions.borderWidth
        //cornerRadius = Configs.BaseDimensions.cornerRadius
        //height(Configs.BaseDimensions.textFieldHeight)
    }
}


