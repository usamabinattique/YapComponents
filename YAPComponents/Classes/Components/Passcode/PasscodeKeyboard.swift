//
//  Keyboard.swift
//  CustomRoubdedKeyboard
//
//  Created by Wajahat Hassan on 13/06/2019.
//  Copyright © 2019 digitify. All rights reserved.
//

import UIKit

public extension UIFactory {
    static func makePasscodeKeyboard(font: UIFont,
                                     biomatryImage:UIImage? = nil,
                                     backImage:UIImage? = nil) -> PasscodeKeyboard {
        let keyboard = PasscodeKeyboard()
        keyboard.font = font
        keyboard.biomatryButton.setImage(biomatryImage, for: .normal)
        keyboard.backButton.setImage(backImage, for: .normal)
        return keyboard
    }
}

open class PasscodeKeyboard: UIView {
    
    open var themeColor: UIColor = .darkGray { didSet {//.appColor(ofType: .primary)
        one.themeColor = themeColor
        two.themeColor = themeColor
        three.themeColor = themeColor
        four.themeColor = themeColor
        five.themeColor = themeColor
        six.themeColor = themeColor
        seven.themeColor = themeColor
        eight.themeColor = themeColor
        nine.themeColor = themeColor
        zero.themeColor = themeColor
        backButton.tintColor = themeColor
    }}
    
    open var font: UIFont = UIFont.systemFont(ofSize: 22) { didSet {
        one.buttonFont = font
        two.buttonFont = font
        three.buttonFont = font
        four.buttonFont = font
        five.buttonFont = font
        six.buttonFont = font
        seven.buttonFont = font
        eight.buttonFont = font
        nine.buttonFont = font
        zero.buttonFont = font
    }}
    
    public let minimumKeyboardHeight: CGFloat = 305
    let buttonRowSpacing: CGFloat = 25
    let buttonColumnSpacing: CGFloat = 25
    let buttonTitleFontSize: CGFloat = 28
    let passcodeValue: String = ""
    var biometryEnabled: Bool = false

    
    // MARK: KEYBOARD KEYS
    public lazy var one = UICircularButton(title: "1", themeColor: themeColor)
    public lazy var two = UICircularButton(title: "2", themeColor: themeColor)
    public lazy var three = UICircularButton(title: "3", themeColor: themeColor)
    public lazy var four = UICircularButton(title: "4", themeColor: themeColor)
    public lazy var five = UICircularButton(title: "5", themeColor: themeColor)
    public lazy var six = UICircularButton(title: "6", themeColor: themeColor)
    public lazy var seven = UICircularButton(title: "7", themeColor: themeColor)
    public lazy var eight = UICircularButton(title: "8", themeColor: themeColor)
    public lazy var nine = UICircularButton(title: "9", themeColor: themeColor)
    public lazy var zero = UICircularButton(title: "0", themeColor: themeColor)
    
    public lazy var backButton: UIButton = {
        let button = UIButton()
        //button.setImage(UIImage(named: "icon_delete_purple", in: yapKitBundle, compatibleWith: nil)?.asTemplate, for: .normal)
        //button.backgroundColor = themeColor //button.tintColor = .primary
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    public lazy var biomatryButton: UIButton = {
        let button = UIButton()
        ///let type = BiometricsManager().deviceBiometryType
        //var imageName: String = "icon_touch_id" //""
        ///if case BiometryType.faceID = type { imageName = "icon_face_id"} else { imageName = "icon_touch_id" }
        ///button.setImage(UIImage(named: imageName, in: yapKitBundle, compatibleWith: nil), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    public lazy var dummyButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = buttonRowSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var stackViewOne: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = buttonColumnSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var stackViewTwo: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = buttonColumnSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var stackViewThree: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = buttonColumnSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var stackViewFour: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = buttonColumnSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    // MARK: - Inits
    public init(biometryEnabled: Bool = false) {
        self.biometryEnabled = biometryEnabled
        super.init(frame: CGRect.zero)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        setupViews()
        setupConstraints()
        
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupViews() {
        stackViewOne.addArrangedSubview(one)
        stackViewOne.addArrangedSubview(two)
        stackViewOne.addArrangedSubview(three)
        
        stackViewTwo.addArrangedSubview(four)
        stackViewTwo.addArrangedSubview(five)
        stackViewTwo.addArrangedSubview(six)
        
        stackViewThree.addArrangedSubview(seven)
        stackViewThree.addArrangedSubview(eight)
        stackViewThree.addArrangedSubview(nine)
        
        self.biometryEnabled ? stackViewFour.addArrangedSubview(biomatryButton) : stackViewFour.addArrangedSubview(dummyButton)
        stackViewFour.addArrangedSubview(zero)
        stackViewFour.addArrangedSubview(backButton)
        
        stackView.addArrangedSubview(stackViewOne)
        stackView.addArrangedSubview(stackViewTwo)
        stackView.addArrangedSubview(stackViewThree)
        stackView.addArrangedSubview(stackViewFour)
        addSubview(stackView)
    }
    
    private func setupConstraints() {
        
        stackView
            .alignAllEdgesWithSuperview()
        
//        let stackViewContraints = [
//            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            stackView.topAnchor.constraint(equalTo: topAnchor),
//            trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
//            bottomAnchor.constraint(equalTo: stackView.bottomAnchor)
//        ]
//
//        NSLayoutConstraint.activate(stackViewContraints)
    }
    
}
