//
//  BaseProtocol.swift
//  YAPComponents
//
//  Created by Umair  on 17/01/2022.
//

import Foundation

public protocol ViewDesignable {
    
    func setupSubViews()
    func setupConstraints()
    func setupBindings()
    func setupTheme()
    func setupResources()
    func setupLocalizedStrings()
    
}

public extension ViewDesignable {
    
    func setupResources() {}
    func setupLocalizedStrings() {}

}
