//
//  AppTheme.swift
//  YAPKit
//
//  Created by Zain on 17/06/2019.
//  Copyright © 2019 YAP. All rights reserved.
//

import Foundation
import RxSwift

public enum AppColorTheme {
    case yap
//    case household
}

public enum AppFontTheme {
    case main
}

public class AppTheme {
    
    public static let shared = AppTheme(colorTheme: .yap, fontTheme: .main)
    
    public var colorTheme: AppColorTheme!
    public var fontTheme: AppFontTheme!
    
    private let disposeBag = DisposeBag()
    
    private init(colorTheme: AppColorTheme, fontTheme: AppFontTheme) {
        self.colorTheme = colorTheme
        self.fontTheme = fontTheme
        
        self.colorTheme = .yap
        
//        SessionManager.current.currentAccount.map{ $0?.accountType }.unwrap().subscribe(onNext: { [weak self] in
//            self?.colorTheme = .yap//$0 == .b2cAccount ? .yap : $0 == .household ? .household : .yap
//        }).disposed(by: disposeBag)
    }
    
    public func setThemes(colorTheme: AppColorTheme, fontTheme: AppFontTheme) {
        self.colorTheme = colorTheme
        self.fontTheme = fontTheme
    }
}
