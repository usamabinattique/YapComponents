//
//  CardBlockOptionsFactory.swift
//  YAPKit
//
//  Created by Muhammad Hassan on 16/09/2019.
//  Copyright © 2019 YAP. All rights reserved.
//

import Foundation

public class CardBlockOptionsFactory {
    public class func createCardBlockOptions() -> [OptionPickerItem<PaymentCardBlockOption>] {
        return [
            OptionPickerItem(title:  "screen_report_card_button_damage_card".localized, icon: UIImage.sharedImage(named: "icon_damaged_card"), value: PaymentCardBlockOption.damage),
            OptionPickerItem(title:  "screen_report_card_button_lost_stolen_card".localized, icon: UIImage.sharedImage(named: "icon_lost_stolen_card"), value: PaymentCardBlockOption.lostOrStolen)
            
        ]
    }
}
