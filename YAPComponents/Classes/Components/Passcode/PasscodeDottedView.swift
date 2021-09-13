//
//  PasscodeDotedView.swift
//  CustomRoubdedKeyboard
//
//  Created by Wajahat Hassan on 17/06/2019.
//  Copyright © 2019 digitify. All rights reserved.
//

import Foundation
import UIKit

//if doted view range is six than in storyboard width is 146 and height should be equal to 16.
//if doted view range is four than in storyboard width is 94 and height should be equal to 16.

public class PasscodeDottedView: UIView {
    
    private var views: [UIView] = []
    private let dotsSpacing: CGFloat = 10
    private let borderWidth: CGFloat = 1.0
    public var themeColor: UIColor = .blue { didSet {
        stackView.arrangedSubviews.forEach {[weak self] in $0.backgroundColor = self?.themeColor }
    }}
    
    private var roundedViewSize: CGFloat = 16
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = dotsSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    public init() {
        super.init(frame: CGRect.zero)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        for view in views {
            view.layoutIfNeeded()
            view.layer.cornerRadius = view.frame.height/2
        }
    }
    
    func commonInit() {
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        setupConstraints()
    }
    
    fileprivate func addDot() {
        let view = UIView()
        view.backgroundColor = themeColor
        view.translatesAutoresizingMaskIntoConstraints = false
        let viewConstraints = [
            view.heightAnchor.constraint(equalToConstant: roundedViewSize),
            view.widthAnchor.constraint(equalToConstant: roundedViewSize)
        ]
        NSLayoutConstraint.activate(viewConstraints)
        view.clipsToBounds = true
        view.layer.cornerRadius = roundedViewSize/2
        stackView.addArrangedSubview(view)
    }
    
    public func characters(total: Int) {
        if stackView.arrangedSubviews.count < total { addDot() } else if stackView.arrangedSubviews.count > total {  removeDot() } else { return }
        characters(total: total)
    }
    
    fileprivate func removeDot() {
        if let view = stackView.arrangedSubviews.last {
            view.removeFromSuperview()
        }
    }
    
    private func setupConstraints() {
        let stackViewContraints = [
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            bottomAnchor.constraint(equalTo: stackView.bottomAnchor)
        ]
        NSLayoutConstraint.activate(stackViewContraints)
    }
}
