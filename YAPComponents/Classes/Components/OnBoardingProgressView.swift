//
//  OnBoardingProgressView.swift
//  YAPKit
//
//  Created by Zain on 20/06/2019.
//  Copyright © 2019 YAP. All rights reserved.
//

import UIKit

public class OnBoardingProgressView: UIView {
    
    public override var tintColor: UIColor! {
        set {
            super.tintColor = newValue
            progressView.progressTintColor = newValue
            backButton.backgroundColor = newValue
            if isCompleted {
                completionView.backgroundColor = newValue
                completionView.tintColor = .white
            }
        }
        get {
            return super.tintColor
        }
    }
    
    public var disabledColor:UIColor! {
        set {
            progressView.backgroundColor = newValue.withAlphaComponent(0.16)
            if !isCompleted {
                completionView.backgroundColor = newValue.withAlphaComponent(0.16)
                completionView.tintColor = newValue.withAlphaComponent(0.5)
            }
        }
        get {
            return progressView.backgroundColor?.withAlphaComponent(1)
        }
    }
    
    public var backImage:UIImage? {
        set {
            backButton.setImage(newValue?.withRenderingMode(.alwaysTemplate), for: .normal)
        }
        get {
            return backButton.image(for: .normal)
        }
    }
    
    public var completionImage:UIImage? {
        set {
            completionView.setImage(newValue?.withRenderingMode(.alwaysTemplate), for: .normal)
        }
        get {
            return backButton.image(for: .normal)
        }
    }
    
    public lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(nil, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        return button
    }()
    
    fileprivate lazy var completionView: UIButton = {
        let button = UIButton()
        button.setImage(nil, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        return button
    }()
    
    fileprivate lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.translatesAutoresizingMaskIntoConstraints = false
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
    
    fileprivate lazy var isCompleted: Bool = false
    
    public var animationCompleted: (() ->Void)?
    
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
        completionView.backgroundColor = tintColor
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
        ///completionView.backgroundColor = UIColor.appColor(ofType: .primary).withAlphaComponent(0.15)
        ///completionView.tintColor = UIColor.appColor(ofType: .primary).withAlphaComponent(0.15)
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
            self.animationCompleted?()
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
}

