//
//  View.swift
//  iOSApp
//
//  Created by Abbas on 07/06/2021.
//

import UIKit

public class View: UIView {
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

public class CircularView:View {
    public override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.size.height / 2
    }
}

public extension UIView {

    var inset: CGFloat { return 0 } //Configs.BaseDimensions.inset }


}

