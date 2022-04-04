//
//  WarningView.swift
//  YAPComponents
//
//  Created by Awais on 04/04/2022.
//

import Foundation

public class WarningView: UIView {
    
    // MARK: Views
    let exclamationImageView = UIFactory.makeImageView(image: UIImage.sharedImage(named: "icon_invalid")?.asTemplate, contentMode: .scaleAspectFit, rendringMode: .alwaysOriginal) //UIImageViewFactory.createImageView(mode: .scaleAspectFit, image: UIImage.sharedImage(named: "icon_invalid")?.asTemplate, tintColor: .white)
    
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
        backgroundColor = .red //--------- tempchange
    }
    
    private func setupConstraints() {
        exclamationImageView.alignAllEdgesWithSuperview()
    }
}
