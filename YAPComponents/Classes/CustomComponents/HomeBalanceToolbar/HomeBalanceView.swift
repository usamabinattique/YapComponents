//
//  CurrencyView.swift
//  YAPKit
//
//  Created by Zain on 27/08/2019.
//  Copyright © 2019 YAP. All rights reserved.
//

import Foundation

class HomeBalanceView: UIView {
    
    private lazy var currency: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.primary.withAlphaComponent(0.16)
        label.font = .small
        label.textColor = .primary
        label.textAlignment = .center
        label.layer.cornerRadius = 11
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var ammount: UILabel = {
        let label = UILabel()
        label.textColor = .grey
        label.font = UIFont.appFont(ofSize: 38, weight: .regular, theme: .main)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.4
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var ammountFront: UILabel = {
        let label = UILabel()
        label.textColor = .primaryDark
        label.font = UIFont.appFont(ofSize: 38, weight: .regular, theme: .main)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.alpha = 0
        label.minimumScaleFactor = 0.4
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var dashboardCurrency: Balance! {
        didSet {
            currency.text = dashboardCurrency.currencyCode.uppercased()
            
            let text = dashboardCurrency.formattedBalance(showCurrencyCode: false, shortFormat: true)
            
            let attributedString = NSMutableAttributedString(string: text)
            
            guard let decimal = text.components(separatedBy: ".").last else { return }
            
            attributedString.addAttribute(.font, value: UIFont.appFont(ofSize: 18, weight: .regular, theme: .main), range: NSRange(location: text.count-decimal.count, length: decimal.count))
            
            ammount.attributedText = attributedString
            ammountFront.attributedText = attributedString
        }
    }
    
    var visible = false {
        didSet {
            currency.alpha = visible ? 1 : 0
            ammountFront.alpha = visible ? 1 : 0
        }
    }
    
    override var tag: Int {
        didSet {
            visible = tag == 0
        }
    }
    
    private var amountCenter: NSLayoutConstraint!
    private var frontAmountCenter: NSLayoutConstraint!
    private var rightShiftSpace: CGFloat = 16.0
    // MARK: Initialization
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        translatesAutoresizingMaskIntoConstraints = false
        
        setupViews()
        setupConstraints()
    }
    
    func changeThemeColor(to color: UIColor) {
        ammountFront.textColor = color
        ammount.textColor = color
        currency.textColor = color
    }
}

// MARK: View setup

private extension HomeBalanceView {
    
    func setupViews() {
        addSubview(currency)
        addSubview(ammount)
        addSubview(ammountFront)
    }
    
    func setupConstraints() {
        currency
            .width(constant: 60)
            .height(constant: 22)
            .alignEdgeWithSuperview(.top)
            .centerHorizontallyInSuperview()
        
        ammount
            .alignEdgeWithSuperview(.bottom)
            .width(with: .width, .lessThanOrEqualTo, ofView: self, multiplier: 1.2)
        
        ammountFront
            .alignEdgeWithSuperview(.bottom)
            .width(with: .width, .lessThanOrEqualTo, ofView: self, multiplier: 1.2)
        
        amountCenter = ammount.centerXAnchor.constraint(equalTo: centerXAnchor, constant: rightShiftSpace)
        amountCenter.isActive = true
        
        frontAmountCenter =  ammountFront.centerXAnchor.constraint(equalTo: centerXAnchor, constant: rightShiftSpace)
        frontAmountCenter.isActive = true
        
    }
}

// MARK: Animation

extension HomeBalanceView {
    
    func setScrollOffset(_ offset: CGFloat) {
        guard bounds.width > 0 else {
            visible = tag == 0
            return
        }
        
        let distance = abs((CGFloat(tag) * bounds.width) - offset)
        if distance == 0 {
            visible = true
        } else if distance >= bounds.width * 0.70 {
            visible = false
        } else {
            let alpha = 1 - (distance / (bounds.width * 0.70))
            currency.alpha = alpha
            ammountFront.alpha = alpha
        }
    }
    
    func changeHeight(by height: CGFloat) {
        let height = height > 1 ? 1 : height
        currency.alpha = height

        let tranform = CGAffineTransform(scaleX: 0.6 + (height * 0.4), y: 0.6 + (height * 0.4))
        ammount.transform = tranform
        ammountFront.transform = tranform
    }
    
    func moveLeft(by height: CGFloat) {
        let offset = (abs(1 - height) * bounds.width)
        
        amountCenter.constant = -offset
        frontAmountCenter.constant = -offset
        
    }
    
    func moveRight(by height: CGFloat) {
        let offset = (abs(1 - height) * bounds.width)
        
        amountCenter.constant = offset
        frontAmountCenter.constant = offset
    }
}
