//
//  HouseholdCustomRoundedButton.swift
//  YAPKit
//
//  Created by Wajahat Hassan on 08/01/2020.
//  Copyright © 2020 YAP. All rights reserved.
//

import Foundation
import RxSwift

public class CustomRoundedButton: UIButton {
    
    public var titleColor: UIColor = .appColor(ofType: .white) {
        didSet{
            setTitleColor()
        }
    }
    
    public var title: String = "" {
        didSet{
            setTitle()
        }
    }
    
    public var setBackgroundColor: UIColor = .appColor(ofType: .primary) {
        didSet{
            setButtonBackgroundColor()
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
        setupViews()
        setupConstraints()
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: View cycle
    override public func layoutSubviews() {
        super.layoutSubviews()
        render()
        layer.cornerRadius = bounds.height / 2
        clipsToBounds = true
    }
    
    private func render() {
        roundView()
    }
    
    public override func draw(_ rect: CGRect) {
        setButtonBackgroundColor()
    }
    
}

private extension CustomRoundedButton {
    
    func setupConstraints() {
        self.alignAllEdgesWithSuperview()
    }
    
    func setupViews() {
        titleLabel?.font = .appFont(forTextStyle: .large)
    }
    
    func setTitleColor() {
        setTitleColor(titleColor, for: .normal)
    }
    
    func setTitle() {
        setTitle(title, for: .normal)
    }
    
    func setButtonBackgroundColor() {
        setBackgroundImage(UIImage.make(size: self.bounds.size, color: setBackgroundColor), for: .normal)
    }
    
}
