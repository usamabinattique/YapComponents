//
//  YAPCard.swift
//  YAPKit
//
//  Created by Zain on 04/09/2019.
//  Copyright © 2019 YAP. All rights reserved.
//

import Foundation

public enum YAPCard {
    case primarySliver
    case virtualDarkBlue
    case virtualGreen
    case virtualMulti
    case virtualLightBlue
    case virtualPurple
    case premiumRoseGold
    case premiumGold
    case premiumBlack
    case premiumGrey
    case metalBlack
    case metalRoseGold
    case metalGrey
    case founderCard
}

public extension YAPCard {
    var cardImage: UIImage? {
        switch self {
        case .primarySliver:
            return UIImage.sharedImage(named: "image_spare_card_silver")
        case .virtualDarkBlue:
            return UIImage.sharedImage(named: "image_virtual_dark_blue")
        case .virtualGreen:
            return UIImage.sharedImage(named: "image_virtual_green")
        case .virtualMulti:
            return UIImage.sharedImage(named: "image_virtual_multi")
        case .virtualLightBlue:
            return UIImage.sharedImage(named: "image_virtual_light_blue")
        case .virtualPurple:
            return UIImage.sharedImage(named: "image_virtual_purple")
        case .premiumRoseGold:
            return UIImage.sharedImage(named: "image_premium_card_rose_gold")
        case .premiumGold:
            return UIImage.sharedImage(named: "image_premium_card_gold")
        case .premiumGrey:
            return UIImage.sharedImage(named: "image_premium_card_grey")
        case .premiumBlack:
            return UIImage.sharedImage(named: "image_premium_card_black")
        case .metalBlack:
            return UIImage.sharedImage(named: "image_metal_card_black")
        case .metalRoseGold:
             return UIImage.sharedImage(named: "image_metal_card_black")
        case .metalGrey:
             return UIImage.sharedImage(named: "image_metal_card_black")
        case .founderCard:
            return UIImage.sharedImage(named: "image_founder_card")
        }
    }
    
    static var dummyCard: UIImage? {
        UIImage.sharedImage(named: "image_card_dummy")
    }
    
    var cardBackImage: UIImage? {
        switch self {
        case .primarySliver, .virtualPurple, .virtualLightBlue, .virtualMulti, .virtualDarkBlue, .virtualGreen, .founderCard:
            return UIImage.sharedImage(named: "silver Cardback")
        case .premiumRoseGold:
            return UIImage.sharedImage(named: "rosegold Cardback")
        case .premiumGold:
            return UIImage.sharedImage(named: "gold Cardback")
        case .premiumGrey:
            return UIImage.sharedImage(named: "silver Cardback")
        case .premiumBlack:
            return UIImage.sharedImage(named: "black Cardback")
        case .metalBlack:
            return UIImage.sharedImage(named: "black Cardback")
        case .metalRoseGold:
             return UIImage.sharedImage(named: "rosegold Cardback")
        case .metalGrey:
             return UIImage.sharedImage(named: "silver Cardback")
        }
    }

    
    var name: String? {
        switch self {
        case .virtualPurple, .virtualLightBlue, .virtualMulti, .virtualDarkBlue, .virtualGreen:
            return "Virtual card"
        case .primarySliver, .founderCard:
            return "commone_disply_text_card_name_primary_silver".localized
        case .premiumRoseGold:
            return "commone_disply_text_card_name_premium_rose_gold".localized
        case .premiumGold:
            return "commone_disply_text_card_name_premium_gold".localized
        case .premiumGrey:
            return "commone_disply_text_card_name_premium_grey".localized
        case .premiumBlack:
            return "commone_disply_text_card_name_premium_black".localized
        case .metalBlack:
            return "commone_disply_text_card_name_metal_black".localized
        case .metalRoseGold:
            return "commone_disply_text_card_name_metal_black".localized
        case .metalGrey:
            return "commone_disply_text_card_name_metal_black".localized
        }
    }
    
     var hexCode: String {
        get {
            switch self {
            case .premiumGold:
                return "#BDA147"
            case .premiumRoseGold, .metalRoseGold:
                return "#B18684"
            case .premiumBlack, .metalBlack:
                return "#434143"
            case .premiumGrey , .metalGrey:
                return "#9A989E"
            case .primarySliver, .virtualPurple, .virtualLightBlue, .virtualMulti, .virtualDarkBlue, .virtualGreen, .founderCard:
                return ""
            }
        }
    }
    
    var gradiants: [UIColor] {
        switch self {
        case .virtualDarkBlue:
            return [.rgba(r: 69, g: 76, b: 86), .rgba(r: 24, g: 33, b: 95)]
        case .virtualGreen:
            return [.rgba(r: 68, g: 215, b: 182), .rgba(r: 203, g: 225, b: 231)]
        case .virtualMulti:
            return [.rgba(r: 136, g: 200, b: 249), .rgba(r: 139, g: 72, b: 156)]
        case .virtualLightBlue:
            return [.rgba(r: 72, g: 189, b: 211), .rgba(r: 72, g: 189, b: 211)]
        case .virtualPurple:
            return [.rgba(r: 166, g: 130, b: 255), .rgba(r: 166, g: 130, b: 255)]
        default:
            return [.primary, .primary]
        }
    }
    
    var cardImageUrl: String? {
        guard let image = cardImage else { return nil }
        guard let imageURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("\(UUID().uuidString).png") else { return nil }
        
        do {
            try image.pngData()?.write(to: imageURL)
        } catch {
            return nil
        }
        return imageURL.absoluteString
    }
    
}
