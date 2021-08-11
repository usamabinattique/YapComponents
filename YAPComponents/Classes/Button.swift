//
//  Button.swift
//  YAPComponents
//
//  Created by Sarmad on 10/08/2021.
//

import UIKit

public class Button:UIButton {
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        layoutSetup()
    }
    
}

//MARK: Private Methods
fileprivate extension Button {
    func layoutSetup() {
        translatesAutoresizingMaskIntoConstraints = false
        //button.titleLabel?.font = UIFont.appFont(forTextStyle: .large,weight: .medium)
    }
}
