//
//  FloatingTextField.swift
//  Pods
//
//  Created by Sarmad on 19/10/2021.
//

import Foundation

public class FloatingTextField: UITextField {

    //MARK: Properties
    private lazy var bottomLine: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    public var bottomLineColorWhileEditing: UIColor? { didSet {
        if isFirstResponder { bottomLine.backgroundColor = bottomLineColorWhileEditing }
    } }

    public var bottomLineColorNormal: UIColor? { didSet {
        if !isFirstResponder { bottomLine.backgroundColor = bottomLineColorNormal }
    } }

    public lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    public override var placeholder: String? {
        set { placeholderLabel.text = newValue }
        get { return placeholderLabel.text }
    }

    // MARK: Initialization
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    @discardableResult public override func becomeFirstResponder() -> Bool {
        let responder = super.becomeFirstResponder()
        updateResponderView(responder)
        return responder
    }

    @discardableResult public override func resignFirstResponder() -> Bool {
        let responder = super.resignFirstResponder()
        updateResponderView(!responder)
        return responder
    }

//    public func setClearImage(_ image: UIImage?, for state: UIControl.State) {
//        guard let image = image else { return }
//        let clearButton = value(forKey: "_clearButton") as? UIButton
//        clearButton?.setImage(image, for: state)
//        clearButton?.backgroundColor = UIColor.clear
//    }
    
}

// MARK: Drawing
extension FloatingTextField {

    public override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return rect(forBounds: bounds)
    }

    public override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return rect(forBounds: bounds)
    }

    public override func textRect(forBounds bounds: CGRect) -> CGRect {
        return rect(forBounds: bounds)
    }

    private func rect(forBounds bounds: CGRect) -> CGRect {
        let rect = CGRect(x: bounds.origin.x + 1, y: bounds.origin.y + placeholderLabel.frame.size.height, width: bounds.size.width - 2, height:bounds.size.height - placeholderLabel.frame.size.height - 1)
        return rect
    }
}

// MARK: View setup
fileprivate extension FloatingTextField {
    func commonInit() {
        translatesAutoresizingMaskIntoConstraints = false
        setupViews()
        setupConstraints()
    }

    func updateResponderView(_ isResponder: Bool) {
        if isResponder, let color = bottomLineColorWhileEditing {
            bottomLine.backgroundColor = color
        } else if let color = bottomLineColorNormal {
            bottomLine.backgroundColor = color
        }
    }

    func setupViews() {
        borderStyle = .none

        addSubview(placeholderLabel)
        addSubview(bottomLine)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            placeholderLabel.topAnchor.constraint(equalTo: topAnchor),
            placeholderLabel.leftAnchor.constraint(equalTo: leftAnchor),
            placeholderLabel.rightAnchor.constraint(equalTo: rightAnchor),

            bottomLine.leftAnchor.constraint(equalTo: leftAnchor),
            bottomLine.rightAnchor.constraint(equalTo: rightAnchor),
            bottomLine.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomLine.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
}

public extension UIFactory {
    class func makeFloatingTextField(
        font: UIFont? = UIFont.systemFont(ofSize: 16),
        fontPlaceholder: UIFont? = UIFont.systemFont(ofSize: 14),
        clearImage: UIImage? = nil,
        clearButtonMode: UITextField.ViewMode = .never,
        returnKeyType: UIReturnKeyType = .default,
        autocorrectionType: UITextAutocorrectionType = .default,
        capitalization: UITextAutocapitalizationType = .sentences,
        keyboardType: UIKeyboardType? = .default,
        delegate: UITextFieldDelegate? = nil
    ) -> FloatingTextField {
        let textField = FloatingTextField()
        textField.font = font
        textField.placeholderLabel.font = fontPlaceholder
        textField.clearButtonMode = clearButtonMode
        textField.setClearImage(clearImage, for: .normal)
        textField.returnKeyType = returnKeyType
        textField.autocorrectionType = autocorrectionType
        textField.autocapitalizationType = capitalization
        if let keyboardType = keyboardType {
            textField.keyboardType = keyboardType
        } else {
            let view = UIView()
            view.backgroundColor = .clear
            textField.inputView = view
        }
        textField.delegate = delegate
        return textField
    }
}
