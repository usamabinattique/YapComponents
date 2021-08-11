//
//  UserInfoView.swift
//  YAPKit
//
//  Created by Wajahat Hassan on 18/07/2019.
//  Copyright © 2019 YAP. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public class UserInfoView: UIView {
    
    public enum Validation {
        case normal
        case valid
        case invalid
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    // MARK: - Views
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .leading
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    fileprivate lazy var infoTitle: UILabel = {
        let label = UILabel()
        label.textColor = .appColor(ofType: .greyDark)
        label.font =  .appFont(forTextStyle: .small)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate lazy var information: UILabel = {
        let label = UILabel()
        label.textColor = .appColor(ofType: .primaryDark)
        label.font =  .appFont(forTextStyle: .large)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var validationIcon: UIImageView  = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "icon_check", in: yapKitBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor.appColor(ofType: .primary)
        return imageView
    }()
    
    public var icon: UIImage? {
        didSet {
            validationIcon.image = icon
        }
    }
    
    public var validation: UserInfoView.Validation = .valid {
        didSet {
            switch validation {
            case .valid:
                icon = UIImage(named: "icon_check", in: yapKitBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
                validationIcon.tintColor = .appColor(ofType: .primary)
            case .invalid:
                icon = UIImage(named: "icon_invalid", in: yapKitBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
                validationIcon.tintColor = .appColor(ofType: .error)
            case .normal:
                icon = nil
            }
        }
    }
    
}

// MARK: - Setup
fileprivate extension UserInfoView {
    
    func commonInit() {
        setupViews()
        setupConstraints()
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupViews() {
        stackView.addArrangedSubview(infoTitle)
        stackView.addArrangedSubview(information)
        addSubview(stackView)
        addSubview(validationIcon)
    }
    
    func setupConstraints() {
        let stackViewConstraints = [
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            bottomAnchor.constraint(equalTo: stackView.bottomAnchor)
        ]
        
        let validationIconConstraints = [
            validationIcon.centerYAnchor.constraint(equalTo: information.centerYAnchor),
            trailingAnchor.constraint(equalTo: validationIcon.trailingAnchor, constant: 0),
            validationIcon.heightAnchor.constraint(equalToConstant: 20),
            validationIcon.widthAnchor.constraint(equalToConstant: 25)
        ]
        
        NSLayoutConstraint.activate(stackViewConstraints + validationIconConstraints)
    }
}

// MARK: - Binder
public extension Reactive where Base: UserInfoView {
    
     var userInfoTitle: Binder<String?> {
        return self.base.infoTitle.rx.text
    }
    
    var userInformation: Binder<String?> {
        return self.base.information.rx.text
    }
    
    var validation: Binder<UserInfoView.Validation> {
        return Binder(self.base) { view, validation -> Void in
            view.validation = validation
        }
    }
}
