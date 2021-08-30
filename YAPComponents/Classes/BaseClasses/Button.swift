//
//  Button.swift
//  iOSApp
//
//  Created by Abbas on 07/06/2021.
//

import UIKit

public class Button: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        makeUI()
    }

    func makeUI() {
        /* themeService.rx
            .bind({ UIImage(color: $0.secondary, size: CGSize(width: 1, height: 1)) }, to: rx.backgroundImage(for: .normal))
            .bind({ UIImage(color: $0.secondary.withAlphaComponent(0.9), size: CGSize(width: 1, height: 1)) }, to: rx.backgroundImage(for: .selected))
            .bind({ UIImage(color: $0.secondary.withAlphaComponent(0.6), size: CGSize(width: 1, height: 1)) }, to: rx.backgroundImage(for: .disabled))
            .disposed(by: rx.disposeBag) */

        layer.masksToBounds = true
        titleLabel?.lineBreakMode = .byWordWrapping
        
        //cornerRadius = Configs.BaseDimensions.cornerRadius
        //height(Configs.BaseDimensions.buttonHeight)

        updateUI()
    }

    func updateUI() {
        setNeedsDisplay()
    }
}

