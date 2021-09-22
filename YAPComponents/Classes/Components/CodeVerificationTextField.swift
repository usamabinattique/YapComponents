//
//  CodeVerificationTextField.swift
//  YAPKit
//
//  Created by Zain on 25/06/2019.
//  Copyright © 2019 YAP. All rights reserved.
//

import UIKit
//import RxSwift
//import RxCocoa

public extension UIFactory {
    static func makeCodeVerificationTextField( fields:Int = 6,
                                        delegate:UITextFieldDelegate? = nil ) -> CodeVerificationTextField {
        let codeTextField = CodeVerificationTextField()
        codeTextField.numberOfTextFields = fields
        codeTextField.delegate = delegate
        return codeTextField
    }
}

public class CodeVerificationTextField: UITextField {
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var borderedText: BorderedLabel {
        return BorderedLabel()
    }
    
    private var textLabels = [BorderedLabel]()
    
    // MARK: Control properties
    
    public var numberOfTextFields: Int = 6 {
        didSet {
            addTextLabels()
        }
    }
    
    // MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        translatesAutoresizingMaskIntoConstraints = false
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(becomeFirstResponder)))
        borderStyle = .none
        keyboardType = .phonePad
        if #available(iOS 12, *) {
            textContentType = .oneTimeCode
        }
        addTarget(self, action: #selector(textChanged), for: .editingChanged)
        
        setupViews()
        setupConstraints()
        
    }
    
    @objc func textChanged() {
        _ = textLabels.map { [unowned self] in
            $0.highlight = false
            guard let index:Int = self.textLabels.firstIndex(of: $0), text?.count ?? 0 > index else {
                $0.text = nil
                return
            }

            $0.text = text?.stringAt(id: index)
        }
        highlightNext()
    }
    
    // MARK: Responder handling
    
    @discardableResult
    public override func becomeFirstResponder() -> Bool {
        highlightNext()
        return super.becomeFirstResponder()
    }
    
    @discardableResult
    public override func resignFirstResponder() -> Bool {
        _ = textLabels.map { $0.highlight = false }
        return super.resignFirstResponder()
    }
    
    private func highlightNext() {
        let index = (text?.count ?? 0) < numberOfTextFields ? text?.count ?? 0 : numberOfTextFields - 1
        textLabels[index].highlight = true
    }
    
    // MARK: Public functions
    
    public func clearText() {
        text = nil
        textLabels.forEach { $0.text = nil }
    }
}

// MARK: Drawing

extension CodeVerificationTextField {
    public override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return .zero
    }
    
    public override func textRect(forBounds bounds: CGRect) -> CGRect {
        return .zero
    }
    
    public override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return .zero
    }
    
    public override func borderRect(forBounds bounds: CGRect) -> CGRect {
        return .zero
    }
}

// MARK: View setup

private extension CodeVerificationTextField {
    
    func setupViews() {
        addSubview(stackView)
    }
    
    func setupConstraints() {
        
        let stackViewConstraints = [
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 0),
            bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 0)
        ]
        
        NSLayoutConstraint.activate(stackViewConstraints)
    }
    
    func addTextLabels() {
        
        textLabels.removeAll()
        stackView.arrangedSubviews.forEach { stackView.removeArrangedSubview($0) }
        
        var constraints = [NSLayoutConstraint]()
        
        for _ in 0..<numberOfTextFields {
            let borderedTextLabel = borderedText
            constraints.append(borderedTextLabel.widthAnchor.constraint(equalToConstant: 45))
            constraints.append(borderedTextLabel.heightAnchor.constraint(equalTo: heightAnchor))
            
            stackView.addArrangedSubview(borderedTextLabel)
            textLabels.append(borderedTextLabel)
        }
        
        NSLayoutConstraint.activate(constraints)
    }
}

// MARK: BorderedLabel

public class BorderedLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        translatesAutoresizingMaskIntoConstraints = false
        font = UIFont.systemFont(ofSize: 28)
        textAlignment = .center
        textColor = #colorLiteral(red: 0.1529999971, green: 0.1330000013, blue: 0.3840000033, alpha: 1)
        backgroundColor = #colorLiteral(red: 0.8549019608, green: 0.878000021, blue: 0.9409999847, alpha: 1).withAlphaComponent(0.36)
        layer.borderColor = UIColor.clear.cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 5
        clipsToBounds = true
    }
    
    public var highlight: Bool = false {
        didSet {
            layer.borderColor = highlight ? #colorLiteral(red: 0.368627451, green: 0.2078431373, blue: 0.6941176471, alpha: 1) : UIColor.clear.cgColor
        }
    }
}

fileprivate extension String {
    func stringAt(id: Int) -> String {
        return String(self[index(startIndex, offsetBy: id)])
    }
}
