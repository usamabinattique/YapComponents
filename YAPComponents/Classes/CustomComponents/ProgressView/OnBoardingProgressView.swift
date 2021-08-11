//
//  OnBoardingProgressView.swift
//  YAPKit
//
//  Created by Zain on 20/06/2019.
//  Copyright © 2019 YAP. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public class OnBoardingProgressView: UIView {
    
    fileprivate lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(nil, for: .normal)
        button.backgroundColor = UIColor.appColor(ofType: .primary)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage.init(named: "ic_back_enabled", in: yapKitBundle, compatibleWith: nil),
                        for: .normal)
        return button
    }()
    
    fileprivate lazy var completionView: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.appColor(ofType: .primaryLight).withAlphaComponent(0.16)
        button.setImage(nil, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage.init(named: "icon_check", in: yapKitBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = UIColor.primary.withAlphaComponent(0.15)
        button.isUserInteractionEnabled = false
        return button
    }()
    
    fileprivate lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.trackTintColor = UIColor.appColor(ofType: .primary).withAlphaComponent(0.15)
        progressView.progressTintColor = UIColor.appColor(ofType: .primary)
        progressView.barHeight = 3
        progressView.progress = 0.33
        return progressView
    }()
    
    public var showsCompletionView: Bool = true {
        didSet {
            completionView.isHidden = !showsCompletionView
        }
    }
    
    public var showsProgressView: Bool = true {
        didSet {
            progressView.isHidden = !showsProgressView
        }
    }
    
    fileprivate var isCompleted: Bool = false
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        translatesAutoresizingMaskIntoConstraints = false
        
        setupViews()
        setupConstraints()
    }
}

// MARK: View setup

extension OnBoardingProgressView {
    fileprivate func setupViews() {
        backgroundColor = .clear
        
        addSubview(backButton)
        addSubview(progressView)
        addSubview(completionView)
    }
    
    fileprivate func setupConstraints() {
        
        backButton
            .width(with: .height, ofView: self, multiplier: 0.92)
            .height(with: .height, ofView: self, multiplier: 0.92)
            .alignEdgeWithSuperview(.left)
            .centerVerticallyInSuperview()

        progressView
            .toRightOf(backButton, constant: 15)
            .centerHorizontallyInSuperview()
            .centerVerticallyInSuperview()

        completionView
            .width(with: .width, ofView: backButton)
            .height(with: .height, ofView: backButton)
            .alignEdgeWithSuperview(.right)
            .centerVerticallyInSuperview()
        
    }
    
    public override func draw(_ rect: CGRect) {
        render()
    }
    
    fileprivate func render() {
        backButton.layer.cornerRadius = backButton.bounds.size.height/2
        completionView.layer.cornerRadius = completionView.bounds.size.height/2
        
        progressView.layer.cornerRadius = 4
        progressView.clipsToBounds = true
    }
}

// MARK: View methods {

extension OnBoardingProgressView {
    public func completeProgress() {
        if isCompleted {
            undoAnimateCompletion()
        }
        
        progressView.setProgress(1, animated: true)
        completionView.backgroundColor = UIColor.appColor(ofType: .primary)
        completionView.tintColor = .white
        completionView.bounce()
    }
    
    public func setProgress(_ progress: Float) {
        if isCompleted {
            undoAnimateCompletion()
        }
        if progress == 1 {
            completeProgress()
            return
        }
        progressView.setProgress(progress, animated: true)
        completionView.backgroundColor = UIColor.appColor(ofType: .primary).withAlphaComponent(0.15)
        completionView.tintColor = UIColor.appColor(ofType: .primary).withAlphaComponent(0.15)
    }
    
    public func animateCompletion() {
        isCompleted = true
        UIView.animate(withDuration: 0.35, animations: { [unowned self] in
            self.backButton.alpha = 0
            self.progressView.alpha = 0
            var frame = self.completionView.frame
            frame.origin.x = self.bounds.size.width/2 - self.completionView.bounds.size.width/2
            self.completionView.frame = frame
        }) { (_) in
            self.backButton.isHidden = true
            self.progressView.isHidden = true
        }
    }
    
    public func undoAnimateCompletion() {
        isCompleted = false
        UIView.animate(withDuration: 0.35, animations: { [unowned self] in
            self.backButton.isHidden = false
            self.progressView.isHidden = false
            self.backButton.alpha = 1
            self.progressView.alpha = 1
            var frame = self.completionView.frame
            frame.origin.x = self.bounds.size.width - self.completionView.bounds.size.width
            self.completionView.frame = frame
        })
    }
    
    func disableBackButton() {
        backButton.isUserInteractionEnabled = false
        backButton.setImage(nil, for: .normal)
        backButton.backgroundColor = UIColor.appColor(ofType: .primary).withAlphaComponent(0.20)
        backButton.setImage(UIImage.init(named: "ic_back_disabled", in: yapKitBundle, compatibleWith: nil),
                        for: .normal)
    }
    
    func enableBackButton() {
        backButton.backgroundColor = UIColor.appColor(ofType: .primary)
        backButton.isUserInteractionEnabled = true
        backButton.setImage(nil, for: .normal)
        backButton.setImage(UIImage.init(named: "ic_back_enabled", in: yapKitBundle, compatibleWith: nil),
                        for: .normal)
    }
    
    func showBackButton() {
        backButton.isHidden = false
    }
    
    func hideBackButton() {
        backButton.isHidden = true
    }
}

// MARK: Reactive

public extension Reactive where Base: OnBoardingProgressView {
    var progress: Binder<Float> {
        return Binder(self.base) { progressView, progress -> Void in
            progressView.setProgress(progress)
        }
    }
    
    var tapBack: ControlEvent<Void> {
        return self.base.backButton.rx.tap
    }
    
    var animateCompletion: Binder<Bool> {
        return Binder(self.base) { progressView, completion -> Void in
            completion ? progressView.animateCompletion() : progressView .undoAnimateCompletion()
        }
    }
    
    var disableBackButton: Binder<Bool> {
        return Binder(self.base) { progressView, isDisabled -> Void in
            isDisabled ? progressView.disableBackButton() : progressView.enableBackButton()
        }
    }
    
    var hideBackButton: Binder<Bool> {
        return Binder(self.base) { progressView, isHidden -> Void in
            isHidden ? progressView.hideBackButton() : progressView.showBackButton()
        }
    }
}
