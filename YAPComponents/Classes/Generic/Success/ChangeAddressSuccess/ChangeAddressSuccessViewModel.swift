//
//  ChangeAddressSuccessViewModel.swift
//  YAPKit
//
//  Created by Zain on 10/10/2019.
//  Copyright © 2019 YAP. All rights reserved.
//

import Foundation

class ChangeAddressSuccessViewModel: SuccessViewModel {
    
    let address: UserMapAddress
    
    init(address: UserMapAddress) {
        self.address = address
        super.init()
        locallization()
    }
}

extension ChangeAddressSuccessViewModel {
    
    // MARK: - Localizations
    func locallization() {
        headingSubject.onNext("screen_change_address_success_display_text_heading".localized)
        doneButtonTitleSubject.onNext("common_button_done".localized)
        subHeadingSubject.onNext(NSAttributedString(string: "screen_change_address_success_display_text_sub_heading".localized))
        imageSubject.onNext(address.image ?? UIImage.sharedImage(named: "image_meeting_confirmation"))
        
        let title = address.address ?? ""
        let subTitle = address.landmark ?? ""
        
        let attributedString1 = NSMutableAttributedString(string: title + "\n", attributes: [
            .font: UIFont.boldSystemFont(ofSize: 14),
            .foregroundColor: UIColor.primaryDark
        ])
        
        let attributedString2 = NSMutableAttributedString(string: subTitle, attributes: [
            .font: UIFont.small,
            .foregroundColor: UIColor.greyDark
        ])
        
        attributedString1.append(attributedString2)
    
        detailsSubject.onNext(attributedString1)
    }
}
