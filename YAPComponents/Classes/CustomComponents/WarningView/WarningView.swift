//
//  WarningView.swift
//  YAPKit
//
//  Created by Muhammad Hassan on 08/10/2019.
//  Copyright © 2019 YAP. All rights reserved.
//

import Foundation

public class WarningView: UIView {
    
    // MARK: Views
    let exclamationImageView = UIImageViewFactory.createImageView(mode: .scaleAspectFit, image: UIImage.sharedImage(named: "icon_invalid")?.asTemplate, tintColor: .white)
    
    public override func layoutSubviews() {
        layer.cornerRadius = frame.width / 2
    }
    
    // MARK: Initializaion
     public override init(frame: CGRect) {
         super.init(frame: frame)
         commonInit()
     }
     
     required public init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
         commonInit()
     }
     
     private func commonInit() {
         setupViews()
         setupConstraints()
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
     }
    
    private func setupViews() {
        addSubview(exclamationImageView)
        backgroundColor = .secondaryMagenta
    }
    
    private func setupConstraints() {
        exclamationImageView.alignAllEdgesWithSuperview()
    }
}
