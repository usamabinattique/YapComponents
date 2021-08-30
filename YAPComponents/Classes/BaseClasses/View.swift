//
//  View.swift
//  iOSApp
//
//  Created by Abbas on 07/06/2021.
//

import UIKit

public class View: UIView {

    convenience init(width value: CGFloat) {
        self.init()
        widthAnchor.constraint(equalToConstant: value).isActive = true
    }

    convenience init(height value: CGFloat) {
        self.init()
        heightAnchor.constraint(equalToConstant: value).isActive = true
    }

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        makeUI()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        makeUI()
    }

    func makeUI() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.masksToBounds = true
        updateUI()
    }

    func updateUI() {
        setNeedsDisplay()
    }

    func getCenter() -> CGPoint {
        return convert(center, from: superview)
    }
}

public extension UIView {

    var inset: CGFloat { return 0 } //Configs.BaseDimensions.inset }


}

