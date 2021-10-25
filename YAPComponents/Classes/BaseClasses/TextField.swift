//
//  TextField.swift
//  iOSApp
//
//  Created by Abbas on 07/06/2021.
//

import UIKit

public class TextField: UITextField {

    var isCircular = false { didSet {
        invalidateIntrinsicContentSize()
    } }

    convenience public init() {
        self.init(frame: .zero)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        makeUI()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        if isCircular { layer.cornerRadius = frame.size.height / 2 }
    }

    private func makeUI() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.masksToBounds = true
    }
}

// MARK: Utalities
public extension UITextField {
    func setClearImage(_ image: UIImage?, for state: UIControl.State) {
        guard let image = image else { return }
        let clearButton = value(forKey: "_clearButton") as? UIButton
        clearButton?.setImage(image, for: state)
        clearButton?.backgroundColor = UIColor.clear
    }

    var clearImageTint: UIColor? {
        set { (value(forKey: "_clearButton") as? UIButton)?.tintColor = newValue }
        get { return (value(forKey: "_clearButton") as? UIButton)?.tintColor }
    }
}

public extension UIFactory {

    //UITextField = {
    //    let textField = UITextField()
    //    textField.translatesAutoresizingMaskIntoConstraints = false
    //    textField.height(constant: 36)
    //    textField.layer.cornerRadius = 18
    //    textField.textAlignment = .center
    //    textField.clearButtonMode = .always
    //    return textField
    //}()

    class func makeTextField(font: UIFont,
                             isCircular: Bool = false,
                             textAlignment: NSTextAlignment = .left,
                             clearButtonMode: UITextField.ViewMode = .never,
                             returnKeyType: UIReturnKeyType = .default
    ) -> UITextField {
        let textfield = TextField()
        textfield.font = font
        textfield.isCircular = isCircular
        textfield.textAlignment = textAlignment
        textfield.clearButtonMode = clearButtonMode
        textfield.returnKeyType = returnKeyType
        return textfield
    }
}
