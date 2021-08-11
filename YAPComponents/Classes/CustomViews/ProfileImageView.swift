//
//  ProfileImageView.swift
//  YAPKit
//
//  Created by Janbaz Ali on 05/03/2020.
//  Copyright © 2020 YAP. All rights reserved.
//

import Foundation

public class ProfileImageView: UIView {
    // MARK: Views
    public lazy var imageView : UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFill
        imageview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageview.clipsToBounds = true
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    // MARK: Public properties
    
    public var borderColor: CGColor {
        get {
            return layer.borderColor ?? UIColor.white.cgColor
        }
        set(newValue) {
            layer.borderColor = newValue
            setNeedsDisplay()
        }
    }
    
    public var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set(newValue) {
            layer.borderWidth = newValue
            setNeedsDisplay()
        }
    }
    
    // MARK: Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        translatesAutoresizingMaskIntoConstraints = false
        setupViews()
    }
    
    override public func layoutSubviews() {
        setupConstraints()
        roundViews()
    }
}


// MARK: View setup

private extension ProfileImageView {
    
    func setupViews() {
        /// setting self properties
     
        //layer.borderColor = UIColor.white.cgColor
        //layer.borderWidth = 8
        backgroundColor = .white
      
        addSubview(imageView)
    }
    
    func setupConstraints() {
        
        imageView
            .height(constant: bounds.height - borderWidth)
            .width(constant: bounds.height - borderWidth)
            .centerInSuperView()
        print(imageView.frame)
    }
    
    func roundViews()  {
        /// Round corners of current / self view.
        layer.cornerRadius = bounds.height/2
       
        /// Round corners of inner image view.
        let maskingLayer = CAShapeLayer()
        let radius = bounds.width/2
        let centrePading = borderWidth/2
        
        maskingLayer.path = UIBezierPath(arcCenter: CGPoint(x: bounds.midX - centrePading , y: bounds.midY - centrePading), radius: radius - borderWidth , startAngle: CGFloat(-90).deg2rad(), endAngle: CGFloat(270).deg2rad(), clockwise: true).cgPath
        imageView.layer.mask = maskingLayer
    
    }
}
extension CGFloat {

    func deg2rad() -> CGFloat {

        return self * .pi / 180

    }

}
