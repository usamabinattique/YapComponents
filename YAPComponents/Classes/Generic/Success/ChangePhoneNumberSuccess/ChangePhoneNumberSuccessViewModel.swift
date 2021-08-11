//
//  ChangePhoneNumberSuccessViewModel.swift
//  YAPKit
//
//  Created by Wajahat Hassan on 02/10/2019.
//  Copyright © 2019 YAP. All rights reserved.
//

import Foundation
import RxSwift


class ChangePhoneNumberSuccessViewModel: SuccessViewModel {
    
    init(phone: String) {
        super.init()
        locallization(phone: phone)
    }
}

extension ChangePhoneNumberSuccessViewModel {
    
    // MARK: - Localizations
    func locallization(phone: String) {
        headingSubject.onNext( "screen_phone_number_success_display_text_heading".localized)
        doneButtonTitleSubject.onNext( "common_button_done".localized)
        
        let text = String.init(format: "screen_phone_number_success_display_text_sub_heading".localized, phone)
        let attributedString = NSMutableAttributedString(string: text, attributes: [
            .font: UIFont.systemFont(ofSize: 16.0, weight: .regular),
            .foregroundColor: UIColor.greyDark
        ])
        attributedString.addAttribute(.foregroundColor, value: UIColor.primaryDark, range: (text as NSString).range(of: phone))
        subHeadingSubject.onNext(attributedString)
    }
}
