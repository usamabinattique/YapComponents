//
//  ScreenProtectionService.swift
//  YAPKit
//
//  Created by Zain on 23/06/2020.
//  Copyright © 2020 YAP. All rights reserved.
//

import Foundation

public class ScreenProtectionService: NSObject {
    
    // MARK: Properties
    
    public var protectsScreenAgainstRecording = false
    
    public var isScreenBeingRecorded = false {
        didSet {
            guard oldValue != isScreenBeingRecorded else { return }
            isScreenBeingRecorded ? protectScreen() : unprotectScreen()
        }
    }
    
    private var protectedWindow: UIWindow? = nil
    
    // MARK: Singelton
    
    public static let shared = ScreenProtectionService()
    
    // MARK: Initialization
    
    private override init() {
        super.init()
        UIScreen.main.addObserver(self, forKeyPath: "captured", options: .new, context: nil)
    }
    
    deinit {
        UIScreen.main.removeObserver(self, forKeyPath: "captured")
    }
    
    // MARK: Observers
    
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "captured" {
            isScreenBeingRecorded = UIScreen.main.isCaptured
        }
    }
}

// MARK: Service methods

private extension ScreenProtectionService {
    
    func protectScreen() {
        guard protectsScreenAgainstRecording, protectedWindow == nil else { return }
        
        protectedWindow = UIWindow(frame: UIScreen.main.bounds)
        protectedWindow?.windowLevel = .alert + 10000
        protectedWindow?.backgroundColor = .clear
        protectedWindow?.makeKeyAndVisible()
        protectedWindow?.isUserInteractionEnabled = true
        
        let blurEffect = UIBlurEffect(style: .dark)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = UIScreen.main.bounds
        
        protectedWindow?.addSubview(blurredEffectView)
        
        let protectionLabel = UILabelFactory.createUILabel(with: .white, textStyle: .regular, alignment: .center, numberOfLines: 0, lineBreakMode: .byWordWrapping, text: "Your screen is being recorded, you cannont use YAP while screen recording is on.")
        
        protectionLabel.layer.shadowColor = UIColor.black.cgColor
        protectionLabel.layer.shadowRadius = 5.0
        protectionLabel.layer.shadowOpacity = 0.8
        protectionLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
        protectionLabel.layer.masksToBounds = false
        
        protectedWindow?.addSubview(protectionLabel)
        
        protectionLabel.alignEdgesWithSuperview([.left, .right, .top], constants: [20, 20, 100])
    }
    
    func unprotectScreen() {
        guard protectedWindow != nil else { return }
        
        protectedWindow?.resignKey()
        protectedWindow?.isHidden = true
        protectedWindow = nil
    }
}
