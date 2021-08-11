//
//  YapRadioButton.swift
//  YAPKit
//
//  Created by Muhammad Awais on 07/04/2020.
//  Copyright © 2020 YAP. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public class YapRadioButton: UIControl {
    
    // MARK: Views
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage.sharedImage(named: "off")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: Properties
    
    public var fillColor: UIColor = .clear
    
    public var checked: Bool = false {
        didSet {
            sendActions(for: .valueChanged)
            imageView.image = checked ? UIImage.sharedImage(named: "on") : UIImage.sharedImage(named: "off")
        }
    }
    
    public var lightChecked: Bool = false {
        didSet {
            imageView.image = lightChecked ? UIImage.sharedImage(named: "light-on") : UIImage.sharedImage(named: "off")
        }
    }
    
    public override var tintColor: UIColor! {
        didSet {
            imageView.tintColor = tintColor
        }
    }
    
    // MARK: Initialization
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        tintColor = .clear
        backgroundColor = .clear
        setupViews()
        setupConstraints()
    }
}

// MARK: View setup

private extension YapRadioButton {
    func setupViews() {
        addSubview(imageView)
    }
    
    func setupConstraints() {
        imageView.alignEdgesWithSuperview([.left, .top, .right, .bottom], constant: 0)
    }
}

// MARK: Reactive

public extension Reactive where Base: YapRadioButton {
    var checked: ControlProperty<Bool> {
        return base.rx.controlProperty(editingEvents: .valueChanged, getter: { checkBox in
            return checkBox.checked
        }) { (checkBox, checked) in
            checkBox.checked = checked
        }
    }
}

