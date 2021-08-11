//
//  ChangePasscodeSuccessViewModel.swift
//  YAPKit
//
//  Created by Wajahat Hassan on 04/10/2019.
//  Copyright © 2019 YAP. All rights reserved.
//

import Foundation
import RxSwift


class ChangePasscodeSuccessViewModel: SuccessViewModel {
    
    private let disposeBag = DisposeBag()
    
    override init() {
        super.init()
        locallization()
    }
}

extension ChangePasscodeSuccessViewModel {
    
    // MARK: - Localizations
    func locallization() {
        headingSubject.onNext("screen_change_passcode_success_display_text_heading".localized)
        
        doneButtonTitleSubject.onNext( "common_button_done".localized)

        subHeadingSubject.onNext(NSAttributedString(string:  "screen_change_passcode_success_display_text_sub_heading".localized))
    }
}
