//
//  UserAccessRestriction.swift
//  YAPKit
//
//  Created by Zain on 25/08/2020.
//  Copyright © 2020 YAP. All rights reserved.
//

import Foundation

public enum UserAccessRestriction {
    case accountInactive
    case otpBlocked
    case eidBlocked
    case cardFreezeByApp
    case cardFreezeByCSR
    case cardHotlistedByApp
    case cardHotlistedByCSR
    case ibanBlockedByRAKTotal
    case ibanBlockedByRAKDebit
    case ibanBlcokedByRAKCredit
    case cardBlockedByMasterCard
    case cardBlockedByYAPTotal
    case cardBlockedByYAPDebit
    case cardBlockedByYAPCredit
    case debitCardPinBlocked
    case none
    
    private static var alertView: YAPAlertView?
}

// MARK: Blocked features

public extension UserAccessRestriction {
    var blockedFeatures: [CoordinatorFeature] {
        switch self {
        case .cardFreezeByApp, .cardFreezeByCSR:
            return []
        case .cardHotlistedByApp, .cardHotlistedByCSR:
            return [.unfreezeCard, .changePIN, .forgotPIN]
        case .ibanBlockedByRAKTotal:
            return [.sendMoneyTransfer(.domestic), .sendMoneyTransfer(.uaefts), .sendMoneyTransfer(.cbwsi), .sendMoneyTransfer(.rmt), .sendMoneyTransfer(.swift), .topUpByExternalCard, .removeFunds, .addFunds, .y2yTransfer, .unfreezeCard]
        case .ibanBlockedByRAKDebit:
            return [.sendMoneyTransfer(.domestic), .sendMoneyTransfer(.uaefts), .sendMoneyTransfer(.cbwsi), .sendMoneyTransfer(.rmt), .sendMoneyTransfer(.swift), .removeFunds, .addFunds, .y2yTransfer, .unfreezeCard]
        case .ibanBlcokedByRAKCredit:
            return [.topUpByExternalCard, .addFunds, .removeFunds, .unfreezeCard]
        case .cardBlockedByMasterCard:
            return [.unfreezeCard, .changePIN, .forgotPIN]
        case .eidBlocked:
            return [.sendMoneyTransfer(.domestic), .sendMoneyTransfer(.uaefts), .sendMoneyTransfer(.cbwsi), .sendMoneyTransfer(.rmt), .sendMoneyTransfer(.swift), .topUpByExternalCard, .removeFunds, .addFunds, .y2yTransfer, .unfreezeCard, .changePIN, .forgotPIN]
        case .cardBlockedByYAPTotal:
            return [.sendMoneyTransfer(.domestic), .sendMoneyTransfer(.uaefts), .sendMoneyTransfer(.cbwsi), .sendMoneyTransfer(.rmt), .sendMoneyTransfer(.swift), .topUpByExternalCard, .removeFunds, .addFunds, .y2yTransfer, .unfreezeCard]
        case .cardBlockedByYAPDebit:
            return [.sendMoneyTransfer(.domestic), .sendMoneyTransfer(.uaefts), .sendMoneyTransfer(.cbwsi), .sendMoneyTransfer(.rmt), .sendMoneyTransfer(.swift), .removeFunds, .addFunds, .y2yTransfer, .unfreezeCard]
        case .cardBlockedByYAPCredit:
            return [.topUpByExternalCard, .addFunds, .removeFunds, .unfreezeCard]
        case .otpBlocked:
            return [.addSendMoneyBeneficiary, .editSendMoneyBeneficiary, .sendMoneyTransfer(.domestic), .sendMoneyTransfer(.cbwsi), .sendMoneyTransfer(.uaefts), .sendMoneyTransfer(.rmt), .sendMoneyTransfer(.swift), .topUpByExternalCard, .editPhoneNumber, .editEmail, .updateEID, .changePasscode, .forgotPasscode, .reorderDebitCard, .addFunds, .removeFunds, .changePIN, .forgotPIN, .y2yTransfer]
        case .accountInactive:
            return [.sendMoney, .yapToYap, .topUp, .analytics, .cardDetails, .addSpareCard]
        case .debitCardPinBlocked:
            return [.changePIN, .forgotPIN]
        case .none:
            return []
        }
    }
}

public extension UserAccessRestriction {
    
    func showFeatureBlockAlert() {
        guard self != .none else { return }
        
        guard self != .accountInactive else {
            YAPToast.show("common_display_text_account_activation".localized)
            return
        }
        
        let phoneNumber = ""
        let stringFormat = self == .otpBlocked ? "common_display_text_otp_blocked_error" : "common_display_text_feature_blocked_error"
        let message = "\(String.init(format: stringFormat.localized, phoneNumber))\n"
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        let attributed = NSMutableAttributedString(string: message)
        
        attributed.addAttributes([.foregroundColor: UIColor.primaryDark,
                                  .font: UIFont.small,
                                  .paragraphStyle: paragraphStyle],
                                 range: NSRange(location: 0, length: message.count))
        
        attributed.addAttributes([.clickableLink: "livechat",
                                  .foregroundColor: UIColor.primary,
                                  .underlineStyle: NSUnderlineStyle.single.rawValue],
                                 range: (message as NSString).range(of: "live chat"))
        
        attributed.addAttributes([.clickableLink: "phonecall",
                                  .foregroundColor: UIColor.primary,
                                  .underlineStyle: NSUnderlineStyle.single.rawValue],
                                 range: (message as NSString).range(of: phoneNumber))
        
        let alertView = YAPAlertView(icon: nil, text: attributed, primaryButtonTitle: "Ok".localized, cancelButtonTitle: nil)
        
        alertView.show(onPrimaryButtonTap: {
            UserAccessRestriction.alertView = nil
        }, onCancelButtonTap: {
            UserAccessRestriction.alertView = nil
        }) { (link) in
            UserAccessRestriction.alertView = nil
            switch link {
            case "livechat":
                ()
            case "phonecall":
                if let phoneUrl = URL(string: "tel://\(phoneNumber.replacingOccurrences(of: "-", with: "").replacingOccurrences(of: " ", with: ""))") {
                    UIApplication.shared.open(phoneUrl, options: [:], completionHandler: nil)
                }
            default:
                break
            }
        }
        
        UserAccessRestriction.alertView = alertView
    }
}
