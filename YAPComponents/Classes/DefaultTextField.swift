//
//  DefaultTextField.swift
//  YAPComponents
//
//  Created by Tayyab on 09/08/2021.
//

import UIKit

open class DefaultTextField: UITextField {

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    private func setup() {
        backgroundColor = UIColor(white: 0.0, alpha: 0.05)
    }
}
