//
//  ExteranalFlowManager.swift
//  YAPKit
//
//  Created by Zain on 01/02/2021.
//  Copyright © 2021 YAP. All rights reserved.
//

import Foundation

public class ExternalFlowManager {
    public static var externalFlowId: String? = nil
    
    public static func parseDeepUrl(_ url: URL?) {
        externalFlowId = nil
        
        guard
            let `url` = url,
            let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false),
            let flowId = urlComponents.queryItems?.filter({ $0.name == "flow_id" }).first?.value
            else { return }
        
        externalFlowId = flowId
    }
}
