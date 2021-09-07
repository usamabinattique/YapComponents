//
//  UIFactory+StackView.swift
//  YAPComponents
//
//  Created by Tayyab on 07/09/2021.
//

import Foundation

extension UIFactory {
    public class func makeStackView(axis: NSLayoutConstraint.Axis,
                                    alignment: UIStackView.Alignment = .leading,
                                    distribution: UIStackView.Distribution = .fillProportionally,
                                    spacing: CGFloat = 0,
                                    arrangedSubviews: [UIView]? = nil) -> StackView {
        let stackView = arrangedSubviews == nil ? StackView() : StackView(arrangedSubviews: arrangedSubviews!)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = axis
        stackView.alignment = alignment
        stackView.distribution = distribution
        stackView.spacing = spacing

        return stackView
    }
}
