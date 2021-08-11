//
//  UIVerticalButton.swift
//  YAPKit
//
//  Created by Muhammad Hussaan Saeed on 05/09/2019.
//  Copyright © 2019 YAP. All rights reserved.
//

import UIKit

open class UIVerticalButton: UIButton {

    public var image: UIImage? = nil {
        didSet {
            iconImageView.image = image
        }
    }
    
    public var title: String? = nil {
        didSet {
            titleLable.text = title
        }
    }
    
    open override var isEnabled: Bool {
        didSet {
            titleLable.alpha = isEnabled ? 1 : 0.5
            iconImageView.alpha = isEnabled ? 1 : 0.5
        }
    }
    
//    open var onTap: ((_ sender: UIVerticalButton) -> Void)?
    
    public lazy var titleLable: UILabel = UILabelFactory.createUILabel(with: .primary, textStyle: .micro, alignment: .center)
    public lazy var iconImageView: UIImageView = UIImageViewFactory.createImageView(mode: .scaleAspectFit)
    
    public lazy var stackView: UIStackView = UIStackViewFactory.createStackView(with: .vertical, alignment: .center, distribution: .fill, spacing: 7)
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        translatesAutoresizingMaskIntoConstraints = false
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        backgroundColor = .white
        titleLable.tintColor = tintColor
        iconImageView.tintColor = tintColor
        
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(titleLable)
        stackView.isUserInteractionEnabled = false
        addSubview(stackView)
//        let yView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
//        yView.backgroundColor = .yellow
//        yView.isUserInteractionEnabled = false
//        addSubview(yView)
//        titleLable.isUserInteractionEnabled = false
//        iconImageView.isUserInteractionEnabled = false
    }
    
    func setupConstraints() {
        stackView
            .alignEdgesWithSuperview([.left, .top, .right, .bottom], .greaterThanOrEqualTo, constant: 8)
            .centerInSuperView()
    }

//    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.iconImageView.alpha = 0.75
//        self.titleLable.alpha = 0.75
//    }
//
//    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            self.iconImageView.alpha = 1
//            self.titleLable.alpha = 1
//        }
////        if onTap != nil { onTap!(self) }
//    }
}
