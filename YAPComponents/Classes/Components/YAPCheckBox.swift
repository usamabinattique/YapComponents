//
//  YAPCheckBox.swift
//  YAPKit
//
//  Created by Zain on 28/10/2019.
//  Copyright © 2019 YAP. All rights reserved.
//

import UIKit

public class YAPCheckBox: UIControl {
    
    // MARK: Views
    
    public lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        imageView.image = UIImage.sharedImage(named: "icon_check")?.asTemplate
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: Properties
    
    
    public var fillColor: UIColor = UIColor.hexStringToUIColor(hex: "#5E35B1") // primary //.blue
    public var checkedWithAnimation = true
    
    public var checked: Bool = false {
        didSet {
            UIView.animate(withDuration: checkedWithAnimation ? 0.3 : 0.0, animations: {
                self.backgroundColor = self.checked ? self.fillColor : .clear
                self.layer.borderColor = self.checked ? UIColor.clear.cgColor : UIColor.gray.cgColor
                self.imageView.isHidden = !self.checked
            })
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
        tintColor = .white
        backgroundColor = .clear
        setupViews()
        setupConstraints()
        render()
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped)))
    }
    
    // MARK: Actions
    
    @objc
    func tapped() {
        checked = !checked
        sendActions(for: .valueChanged)
    }
}

// MARK: View setup

private extension YAPCheckBox {
    func setupViews() {
        addSubview(imageView)
    }
    
    func setupConstraints() {
        imageView.alignEdgesWithSuperview([.left, .top, .right, .bottom], constant: 4)
    }
    
    func render() {
        layer.cornerRadius = 4
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 1
        clipsToBounds = true
    }
}
