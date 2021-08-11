//
//  SecureByYAPView.swift
//  YAPKit
//
//  Created by Muhammad Hussaan Saeed on 04/10/2019.
//  Copyright © 2019 YAP. All rights reserved.
//

import UIKit


public class SecureByYAPView: UIView {
    
    private lazy var imageView: UIImageView = UIImageViewFactory.createImageView(mode: .scaleAspectFit, image: UIImage.sharedImage(named: "icon_secure"))
    private lazy var textLable: UILabel = UILabelFactory.createUILabel(with: .greyDark, textStyle: .micro, text: "screen_payment_card_detail_text_secure".localized)
    
    private lazy var stackView: UIStackView = UIStackViewFactory.createStackView(with: .horizontal, alignment: .center, distribution: .fill, spacing: 9, arrangedSubviews: [imageView, textLable])
    
    // MARK: - Init
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    internal func commonInit() {
        translatesAutoresizingMaskIntoConstraints = false
        setupViews()
        setupConstraints()
    }
    
    fileprivate func setupViews() {
        addSubview(stackView)
    }
    
    fileprivate func setupConstraints() {
        
        stackView
            .alignAllEdgesWithSuperview()
        
        imageView
            .width(with: .height, ofView: imageView)
            .height(constant: 16)
    }
    
}
