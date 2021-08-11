//
//  PaymentCard.swift
//  YAP
//
//  Created by Hussaan S on 30/01/2019.
//  Copyright © 2019 YAP. All rights reserved.
//

import UIKit

public enum PaymentCardFeature {
    case everyNeed
    case virtualOrPhysical
    case nickname
    case freezeOrUnfreeze
    case sendSalaries
    case allocateBudget
    case setUpPayments
    case trackExpenses
    case addInstantly
    case onlinePayments
    case funds
    case realTimeExchangeRate
    case freeATMWithdrawls
    case travelInsurance
    case priorityCustomerSupport
    case airportLoungeAccess
    case freePackageSubscription
    case exclusivePartnerOffers
}

public extension PaymentCardFeature {
    var title: String {
        switch self {
        case .everyNeed:
            return "screen_add_card_display_text_feature_spare_card_every_need_title".localized
        case .virtualOrPhysical:
            return "screen_add_card_display_text_feature_spare_card_virtual_or_physical_title".localized
        case .nickname:
            return "screen_add_card_display_text_feature_spare_card_nick_name_title".localized
        case .freezeOrUnfreeze:
            return "screen_add_card_display_text_feature_spare_card_freeze_or_unfreeze_title".localized
        case .sendSalaries:
            return "screen_yap_house_hold_subscription_selection_display_text_benefit_send_salaries".localized
        case .allocateBudget:
            return "screen_yap_house_hold_subscription_selection_display_text_benefit_allocate_budget".localized
        case .setUpPayments:
            return "screen_yap_house_hold_subscription_selection_display_text_benefit_setup_payments".localized
        case .trackExpenses:
            return "screen_yap_house_hold_subscription_selection_display_text_benefit_track_expense".localized
        case .addInstantly:
            return "screen_add_card_display_text_feature_spare_card_add_instantly".localized
        case .onlinePayments:
            return "screen_add_card_display_text_feature_spare_card_online_payments".localized
        case .funds:
            return "screen_add_card_display_text_feature_spare_card_funds".localized
        case .exclusivePartnerOffers:
            return "screen_add_card_display_text_feature_exclusive_partner_offers".localized
        case .realTimeExchangeRate:
            return "screen_add_card_display_text_feature_realtime_exchange_rate".localized
        case.airportLoungeAccess:
            return "screen_add_card_display_text_feature_premier_airport_lounge_access".localized
        case .freeATMWithdrawls:
            return "screen_add_card_display_text_feature_free_atm_withdrawals".localized
        case .priorityCustomerSupport:
            return "screen_add_card_display_text_feature_priority_customer_support".localized
        case .freePackageSubscription:
            return "screen_add_card_display_text_feature_free_package_subscription".localized
        case .travelInsurance:
            return "screen_add_card_display_text_feature_travel_insurance".localized
            
        }
        
    }
    
    var description: String {
        switch self {
        case .everyNeed:
            return "screen_add_card_display_text_feature_spare_card_every_need_details".localized
        case .virtualOrPhysical:
            return "screen_add_card_display_text_feature_spare_card_virtual_or_physical_details".localized
        case .nickname:
            return "screen_add_card_display_text_feature_spare_card_nick_name_details".localized
        case .freezeOrUnfreeze:
            return "screen_add_card_display_text_feature_spare_card_freeze_or_unfreeze_details".localized
        case .sendSalaries:
            return "screen_add_card_display_text_feature_spare_card_every_need_details".localized
        case .allocateBudget:
            return "screen_add_card_display_text_feature_spare_card_virtual_or_physical_details".localized
        case .setUpPayments:
            return "screen_add_card_display_text_feature_spare_card_nick_name_details".localized
        case .trackExpenses:
            return "screen_add_card_display_text_feature_spare_card_freeze_or_unfreeze_details".localized
        case .addInstantly, .funds, .onlinePayments, .exclusivePartnerOffers, .freePackageSubscription, .priorityCustomerSupport, .realTimeExchangeRate, .airportLoungeAccess, .freeATMWithdrawls, .travelInsurance:
            return ""
            
        }
    }
}


public enum PaymentCardType: String, Codable {
    case debit = "DEBIT"
    case prepaid = "PREPAID"
}

extension PaymentCardType: Comparable {
    public static func < (lhs: PaymentCardType, rhs: PaymentCardType) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}

public enum CardStatus: String, Codable {
    case active = "ACTIVE"
    case blocked = "BLOCKED"
    case inActive = "INACTIVE"
    case hotlisted = "HOTLISTED"
    case expired = "EXPIRED"
}

public extension CardStatus {
    var leaplumStatus: String {
        switch self {
        case .active:
            return "active"
        case .blocked:
            return "frozen"
        case .inActive:
            return "in-active"
        case .hotlisted:
            return "hotlisted"
        case .expired:
            return "expired"
        }
    }
}

public enum DeliveryStatus: String, Codable {
    case booked = "BOOKED"
    case shipping = "SHIPPING"
    case shipped = "SHIPPED"
    case failed = "FAILED"
    case ordered = "ORDERED"
}

public enum PinStatus: String, Codable {
    case blocked = "BLOCKED"
    case active = "ACTIVE"
}

public enum PaymentCardPlan: String, Codable {
    case spare = "SPARE"
    case premium = "PREMIUM"
    case metal = "METAL"
    
    public var toString: String {
        get {
            return rawValue.prefix(1).uppercased() + rawValue.dropFirst().lowercased() + " card"
        }
    }
    
    public var toLowerCase: String {
        get {
            return rawValue.prefix(1).uppercased() + rawValue.dropFirst().lowercased()
        }
    }
    
    public var colors: [YAPCard] {
        get {
            switch self {
            case .premium:
                return [.premiumRoseGold, .premiumGold, .premiumGrey, .premiumBlack ]
            case .metal:
                return [.metalRoseGold, .metalGrey, .metalBlack]
            case .spare:
                return [.virtualDarkBlue, .virtualGreen, .virtualMulti, .virtualLightBlue, .virtualPurple]
                
            }
        }
    }
    
    public var features : [PaymentCardFeature] {
        get {
            switch self {
            case .premium:
                return [.realTimeExchangeRate, .freeATMWithdrawls, .travelInsurance, .priorityCustomerSupport, .airportLoungeAccess, .freePackageSubscription ]
            case .metal:
                return [.exclusivePartnerOffers, .realTimeExchangeRate, .freeATMWithdrawls, .travelInsurance, .priorityCustomerSupport, .airportLoungeAccess, .freePackageSubscription ]
            case .spare:
                return [.addInstantly, .onlinePayments, .funds, .nickname, .freezeOrUnfreeze]
            }
        }
    }
    
    public var badge: UIImage? {
         switch self {
         case .premium:
             return UIImage.init(named: "icon_gold_badge", in: yapKitBundle, compatibleWith: nil)
         case .metal:
             return UIImage.init(named: "icon_black_badge", in: yapKitBundle, compatibleWith: nil)
         case .spare:
             return UIImage.init(named: "icon_primary_badge", in: yapKitBundle, compatibleWith: nil)
         }
     }
    
}

public enum PaymentCardBlockOption: String, Codable {
    case damage = "4"
    case lostOrStolen = "2"
}

public enum PaymentCardScheme {
    case mastercard
    case visa
    case unknown
}

public struct PaymentCard {
    public let cardScheme: String
    public let uuid: String
    public var cardName: String?
    public let cardType: PaymentCardType
    public let cardPlan: PaymentCardPlan?
    public let balance: String
    public let status: CardStatus
    public let cardSerialNumber: String
    public let accountType: AccountType
    public let panNumber: String?
    public let physical: Bool
    public let pinSet: Bool
    public let atmAllowed: Bool
    public let onlineBankingAllowed: Bool
    public let retailPaymentAllowed: Bool
    public let paymentAbroadAllowed: Bool
    public let delivered: Bool
    public var blocked: Bool
    public var active: Bool
    public var productCode: String
    public var accountNumber: String
    public var customerId: String
    public var expiryDate: String
    public var deliveryStatus: DeliveryStatus? { DeliveryStatus(rawValue: _deliveryStatus ?? "") }
    private let _deliveryStatus: String?
    public let cardNameUpdated: Bool?
    public let deliveryDate: Date?
    public let setPinDate: Date?
    public let frontImageUrl: String?
    public let backImageUrl: String?
    public let pinStatus: PinStatus
    public var imageWithUrl: ImageWithURL {
        let isFounderMember =  false
        if isFounderMember && cardType == .debit {
            return (nil, UIImage.sharedImage(named: "image_founder_card"))
        } else {
            return (frontImageUrl, YAPCard.primarySliver.cardImage)
        }
    }
}

extension PaymentCard: Codable {
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        cardType = try values.decode(PaymentCardType.self, forKey: .cardType)
        cardPlan = try values.decodeIfPresent(PaymentCardPlan.self, forKey: .cardPlan) ?? nil
        uuid = try values.decode(String.self, forKey: .uuid)
        physical = try values.decode(Bool.self, forKey: .physical)
        active = try values.decode(Bool.self, forKey: .active)
        cardName = try values.decodeIfPresent(String.self, forKey: .cardName)
        status = try values.decode(CardStatus.self, forKey: .status)
        blocked = try values.decode(Bool.self, forKey: .blocked)
        delivered = try values.decode(Bool.self, forKey: .delivered)
        cardSerialNumber = try values.decode(String.self, forKey: .cardSerialNumber)
        panNumber = try values.decode(String.self, forKey: .panNumber)
        atmAllowed = try values.decode(Bool.self, forKey: .atmAllowed)
        onlineBankingAllowed = try values.decode(Bool.self, forKey: .onlineBankingAllowed)
        retailPaymentAllowed = try values.decode(Bool.self, forKey: .retailPaymentAllowed)
        paymentAbroadAllowed = try values.decode(Bool.self, forKey: .paymentAbroadAllowed)
        accountType = try values.decode(AccountType.self, forKey: .accountType)
        expiryDate = try values.decode(String.self, forKey: .expiryDate)
        balance = try values.decode(String.self, forKey: .balance)
        cardScheme = try values.decode(String.self, forKey: .cardScheme)
        customerId = try values.decode(String.self, forKey: .customerId)
        productCode = try values.decode(String.self, forKey: .productCode)
        accountNumber = try values.decodeIfPresent(String.self, forKey: .accountNumber) ?? ""
        _deliveryStatus = try values.decodeIfPresent(String.self, forKey: ._deliveryStatus)
        cardNameUpdated = try values.decodeIfPresent(Bool.self, forKey: .cardNameUpdated)
        pinSet = try values.decode(Bool.self, forKey: .pinSet)
        deliveryDate = try? (values.decodeIfPresent(String.self, forKey: .deliveryDate).map { DateFormatter.transactionDateFormatter.date(from: $0) }) ?? nil
        setPinDate = try? (values.decodeIfPresent(String.self, forKey: .setPinDate).map { DateFormatter.transactionDateFormatter.date(from: $0) }) ?? nil
        frontImageUrl = try? values.decode(String?.self, forKey: .frontImageUrl)
        backImageUrl = try? values.decode(String?.self, forKey: .backImageUrl)
        pinStatus = PinStatus(rawValue: (try? values.decode(String?.self, forKey: .pinStatus)) ?? "") ?? .active
    }
    
    enum CodingKeys: String, CodingKey {
        case cardScheme = "cardScheme"
        case uuid = "uuid"
        case cardName = "cardName"
        case cardType = "cardType"
        case cardPlan = "cardPlan"
        case balance = "cardBalance"
        case status = "status"
        case cardSerialNumber = "cardSerialNumber"
        case accountType = "accountType"
        case panNumber = "maskedCardNo"
        case physical = "physical"
        case pinSet = "pinCreated"
        case atmAllowed = "atmAllowed"
        case onlineBankingAllowed = "onlineBankingAllowed"
        case retailPaymentAllowed = "retailPaymentAllowed"
        case paymentAbroadAllowed = "paymentAbroadAllowed"
        case delivered = "delivered"
        case blocked = "blocked"
        case active = "active"
        case productCode = "productCode"
        case accountNumber = "accountNumber"
        case customerId = "customerId"
        case expiryDate = "expiryDate"
        case _deliveryStatus = "deliveryStatus"
        case cardNameUpdated = "nameUpdated"
        case deliveryDate = "shipmentDate"
        case setPinDate = "setPinDate"
        case frontImageUrl = "frontImage"
        case backImageUrl = "backImage"
        case pinStatus = "pinStatus"
    }
}

// MARK: - Unit Testing Utils
public extension PaymentCard {
    init(cardSerialNumber: String) {
        self.cardSerialNumber = cardSerialNumber
        cardScheme = ""
        uuid = ""
        cardName = ""
        cardType = .prepaid
        balance = ""
        status = .active
        accountType = .household
        panNumber = ""
        physical = false
        pinSet = false
        atmAllowed = false
        onlineBankingAllowed = false
        retailPaymentAllowed = false
        paymentAbroadAllowed = false
        delivered = false
        blocked = false
        active = false
        productCode = ""
        accountNumber = ""
        customerId = ""
        expiryDate = ""
        _deliveryStatus = nil
        cardNameUpdated = nil
        cardPlan = nil
        deliveryDate = nil
        setPinDate = nil
        frontImageUrl = nil
        backImageUrl = nil
        pinStatus = .active
    }
}

// MARK: - Equatable
extension PaymentCard: Equatable {
    public static func == (lhs: PaymentCard, rhs: PaymentCard) -> Bool {
        lhs.cardSerialNumber == rhs.cardSerialNumber
    }
}


// MARK: - Mocked extension
extension PaymentCard {
    public static var mock: PaymentCard {
        PaymentCard(cardScheme: "",
                    uuid: "",
                    cardName: "John Doe",
                    cardType: .debit,
                    cardPlan: .metal,
                    balance: "123",
                    status: .active,
                    cardSerialNumber: "21312312",
                    accountType: .b2bAccount,
                    panNumber: "xxxx xxxx xxxx 5458",
                    physical: true,
                    pinSet: true,
                    atmAllowed: true,
                    onlineBankingAllowed: true,
                    retailPaymentAllowed: true,
                    paymentAbroadAllowed: true,
                    delivered: true,
                    blocked: false,
                    active: false,
                    productCode: "CD",
                    accountNumber: "1000000000000101",
                    customerId: "0110000123",
                    expiryDate: "03/22",
                    _deliveryStatus: nil,
                    cardNameUpdated: false,
                    deliveryDate: nil,
                    setPinDate: nil,
                    frontImageUrl: nil,
                    backImageUrl: nil,
                    pinStatus: .active)
    }
    
    public static func makePaymentCard(deliveryStatus: DeliveryStatus,
                                       isPinSet: Bool,
                                       deliveryDate: Date,
                                       activationDate: Date? = nil) -> PaymentCard {
        PaymentCard(cardScheme: "",
                    uuid: "",
                    cardName: "",
                    cardType: .debit,
                    cardPlan: nil,
                    balance: "AED 2252",
                    status: .active,
                    cardSerialNumber: "",
                    accountType: .b2cAccount,
                    panNumber: "",
                    physical: true,
                    pinSet: isPinSet,
                    atmAllowed: true,
                    onlineBankingAllowed: true,
                    retailPaymentAllowed: true,
                    paymentAbroadAllowed: true,
                    delivered: true,
                    blocked: true,
                    active: true,
                    productCode: "",
                    accountNumber: "",
                    customerId: "",
                    expiryDate: "",
                    _deliveryStatus: deliveryStatus.rawValue,
                    cardNameUpdated: true,
                    deliveryDate: deliveryDate,
                    setPinDate: activationDate,
                    frontImageUrl: nil,
                    backImageUrl: nil,
                    pinStatus: .active)
    }
}

public extension PaymentCard {
    static func cardScheme(for pan: String) -> PaymentCardScheme {
        let masterCardRegex = "^(5[1-5]|222[1-9]|22[3-9]|2[3-6]|27[01]|2720)[0-9]{0,}$"
        let visaCardRegex = "^4[0-9]{0,}$"
        let masterCardPredicate = NSPredicate(format: "SELF MATCHES %@", masterCardRegex)
        let visaPredicate = NSPredicate(format: "SELF MATCHES %@", visaCardRegex)
        if masterCardPredicate.evaluate(with: pan) {
            return .mastercard
        } else if visaPredicate.evaluate(with: pan) {
            return .visa
        } else {
            return .unknown
        }
    }
    
    static func cardSchemeImage(for scheme: PaymentCardScheme) -> UIImage? {
        if scheme == .mastercard {
            return UIImage(named: "icon_master_card")
        } else if scheme == .visa {
            return UIImage(named: "icon_visa_blue")
        } else {
            return nil
        }
    }
}

public extension PaymentCard {
    var cardDisplayType: String {
        if cardType == .debit {
            return "commone_disply_text_card_name_primary_silver".localized
        } else {
            return physical ? "common_display_text_spare_physical_card".localized : cardName ?? ""
        }
    }
    
    var shouldSetPin: Bool {
        guard cardType == .debit else { return false }
        return (status == .inActive && (deliveryStatus == .shipped)) || (status == .active && !pinSet)
    }
}

extension PaymentCard: StatementFetchable {
    public var idForStatements: String? {
        return self.cardSerialNumber
    }
    
    public var statementType: StatementType { .card }
}
