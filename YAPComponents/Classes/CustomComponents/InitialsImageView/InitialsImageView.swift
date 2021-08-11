//
//  InitialsImageView.swift
//  YAP
//
//  Created by Muhammad Hassan on 05/10/2018.
//  Copyright © 2018 YAP. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public class InitialsImageView: UIView {
    
    // MARK: - Views
    lazy var backgroundView: UIView = UIView()
    lazy var initialsLabel: UILabel = UILabelFactory.createUILabel(with: .secondaryGreen, textStyle: .title2)
    lazy var imageView: UIImageView = UIImageViewFactory.createImageView()
    lazy var addButtonContainer: UIView = UIView()
    lazy var addButton: UIButton = UIButtonFactory.createButton()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    internal func commonInit() {
        translatesAutoresizingMaskIntoConstraints = false
        setupViews()
        setupConstraints()
    }
    
    // MARK: - Lifecycle
    override public func layoutSubviews() {
        layer.cornerRadius = bounds.width / 2
    }
    
    fileprivate func setupViews() {
        addSubview(backgroundView)
        addSubview(initialsLabel)
        addSubview(imageView)
        addSubview(addButtonContainer)
        addButtonContainer.addSubview(addButton)
    }
    
    fileprivate func setupConstraints() {
        backgroundView.alignAllEdgesWithSuperview()
        initialsLabel.centerInSuperView()
        imageView.centerInSuperView()
        addButton.centerInSuperView()
        addButtonContainer.width(constant: 32).height(constant: 32)
        addButton.pinEdge(.centerX, toEdge: .right, ofView: addButtonContainer, constant: 0)
        addButton.pinEdge(.centerY, toEdge: .bottom, ofView: addButtonContainer, constant: 0)
    }
}

// MARK: - ProfileImageView+Rx
extension Reactive where Base: InitialsImageView {
    
    var image: Binder<UIImage> {
        return Binder(self.base) { initialsImageView, image in
            initialsImageView.imageView.isHidden = false
            initialsImageView.imageView.image = image
            initialsImageView.initialsLabel.isHidden = true
        }
    }
    
    var photoUrl: Binder<URL?> {
        return Binder(self.base) { initialsImageView, url in
            initialsImageView.imageView.isHidden = false
            initialsImageView.imageView.sd_setImage(with: url)
            initialsImageView.initialsLabel.isHidden = true
        }
    }
    
    var initials: Binder<String> {
        return Binder(self.base) { initialsImageView, initials in
            initialsImageView.imageView.isHidden = initialsImageView.imageView.image == nil
            initialsImageView.initialsLabel.isHidden = initialsImageView.imageView.image != nil
            let parts = initials.uppercased().split(separator: " ")
            if parts.count > 1 {
                let firstPart = parts[0]
                let secondPart = parts[1]
                if let first = firstPart.first {
                 initialsImageView.initialsLabel.text = "\(first)"
                }
                if let second = secondPart.first {
                    initialsImageView.initialsLabel.text = "\(initialsImageView.initialsLabel.text ?? "")\(second)"
                }
            } else if parts.count > 0 {
                let firstPart = parts[0]
                if let first = firstPart.first {
                    initialsImageView.initialsLabel.text = "\(first)"
                }
            }
        }
    }
}
