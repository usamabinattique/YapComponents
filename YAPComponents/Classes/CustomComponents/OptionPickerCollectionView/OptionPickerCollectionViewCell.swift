//
//  OptionPickerCollectionViewCell.swift
//  YAPKit
//
//  Created by Muhammad Hassan on 13/09/2019.
//  Copyright © 2019 YAP. All rights reserved.
//

import Foundation

class OptionPickerCollectionViewCell: RxUICollectionViewCell {
    
    // MARK: - Views
    lazy var iconImageView: UIImageView = UIImageViewFactory.createBackgroundImageView(mode: .scaleAspectFit)
    lazy var titleLabel: UILabel = UILabelFactory.createUILabel(with: .primaryDark, textStyle: .micro)
    lazy var contentStackView: UIStackView = UIStackViewFactory.createStackView(with: .vertical, alignment: .center, spacing: 15)
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selection
    override var isSelected: Bool {
        didSet {
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.backgroundColor = self!.isSelected ? UIColor.appColor(ofType: .greyLight) : UIColor.clear
            }
        }
    }
    
    // MARK: - Setup View
    func setupViews() {
        contentStackView.addArrangedSubview(iconImageView)
        contentStackView.addArrangedSubview(titleLabel)
        
        addSubview(contentStackView)
        contentStackView.centerInSuperView()
        layer.cornerRadius = 12
        layer.borderColor = UIColor.appColor(ofType: .greyLight).cgColor
        layer.borderWidth = 1
    }
    
    // MARK: - Configure
    func configure(with optionPickerItem: OptionPickerItem<PaymentCardBlockOption>) {
        iconImageView.image = optionPickerItem.icon
        titleLabel.text = optionPickerItem.title
        iconImageView.tintColor = .primary
    }
}
