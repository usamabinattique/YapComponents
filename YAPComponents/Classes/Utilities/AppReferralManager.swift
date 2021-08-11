//
//  AppReferralManager.swift
//  AppAnalytics
//
//  Created by Zain on 02/03/2020.
//  Copyright © 2020 YAP. All rights reserved.
//

import Foundation

public class AppReferralManager {
    // MARK: Properties
    private static let inviterIdKey = "REFERRAL_INVITER_ID"
    private static let invitationTimeKey = "REFERRAL_INVITATION_TIME"
    
    
    // MARK: Initializtion
    private init() { }
}


// MARK: Public methods

public extension AppReferralManager {
    
    static func getReferralUrl(for inviterId: String, time: Date = Date()) -> String? {
        
        let bundle = Bundle(for: AppReferralManager.self)
        
        guard let baseUrl = bundle.object(forInfoDictionaryKey: "AdjustReferralBaseURL") as? String,
            let iosReferralToken = bundle.object(forInfoDictionaryKey: "AdjustReferraliOSToken") as? String,
            let androidReferralToken = bundle.object(forInfoDictionaryKey: "AdjustReferralAndroidToken") as? String else {
            return nil
        }
        
        var components = URLComponents()
        
        var queryParams = [URLQueryItem]()
        queryParams.append(URLQueryItem(name: "adjust_t", value: [iosReferralToken, androidReferralToken].joined(separator: "_")))
        queryParams.append(URLQueryItem(name: "customer_id", value: inviterId))
        queryParams.append(URLQueryItem(name: "time", value: refferalTimeString()))
        
        components.scheme = "https"
        components.host = baseUrl
        components.queryItems = queryParams
        
        return components.url?.absoluteString
    }
    
    static func refferalTimeString() -> String?  {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.string(from: Date())
    }
    
    static func saveReferralInformation(inviterId: String, time: String) {
        UserDefaults.standard.set(inviterId, forKey: inviterIdKey)
        UserDefaults.standard.set(time, forKey: invitationTimeKey)
    }
    
    static func removeReferralInformation() {
        UserDefaults.standard.removeObject(forKey: inviterIdKey)
        UserDefaults.standard.removeObject(forKey: invitationTimeKey)
    }
    
    static func parseReferralUrl(_ url: URL?) {
        
        guard let `url` = url else { return }
        
        guard let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return }
        
        let inviterId = urlComponents.queryItems?.filter{ $0.name == "customer_id" }.first?.value
        let time = urlComponents.queryItems?.filter{ $0.name == "time" }.first?.value
        
        guard let inviter = inviterId, let invitationTime = time else { return }
        
        saveReferralInformation(inviterId: inviter, time: invitationTime)
    }
    
    static var isReferralInformationAvailable: Bool {
        guard (UserDefaults.standard.object(forKey: inviterIdKey) as? String) != nil, (UserDefaults.standard.object(forKey: invitationTimeKey) as? String) != nil else { return false }
        return true
    }
    
    static var inviterId: String? {
        UserDefaults.standard.object(forKey: inviterIdKey) as? String
    }
    
    static var invitationTime: Date? {
        guard let timeString = UserDefaults.standard.object(forKey: invitationTimeKey) as? String, let timeInterval = Double(timeString) else { return nil }
        return Date(timeIntervalSince1970: timeInterval)
    }
    
    static var invitationTimeString: String? {
        return  UserDefaults.standard.object(forKey: invitationTimeKey) as? String
    }
}
