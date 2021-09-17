//
//  UIAppSwitch.swift
//  YAPKit
//
//  Created by Zain on 13/08/2020.
//  Copyright © 2020 YAP. All rights reserved.
//

import Foundation
//import RxSwift
//import RxCocoa

public class AppSwitch: UIControl {
    
    // MARK: Nob
    
    private let nob = UIImageView()
    
    // MARK: Properties
    
    public var isOn: Bool = false {
        didSet {
            if oldValue != isOn {
                animateChange()
                sendActions(for: .valueChanged)
                touchStartLocation = isOn ? nob.frame.origin.x : nob.frame.origin.x + nob.frame.size.width
            }
        }
    }
    
    public var onImage: UIImage? = nil { didSet {
        if isOn { nob.image = onImage }
    }}
    
    public var offImage: UIImage? = nil { didSet {
        if !isOn { nob.image = offImage }
    }}
    
    public var onTintColor: UIColor = .blue { didSet { if isOn {
        self.backgroundColor = self.onTintColor
        self.nob.tintColor = self.onTintColor
    }}}
    
    public var offTintColor: UIColor = .lightGray{ didSet { if !isOn {
        self.backgroundColor = self.offTintColor
        self.nob.tintColor = self.offTintColor
    }}}
    
    private var touchStartLocation: CGFloat = 0
    private var animating: Bool = false
    
    public override var frame: CGRect {
        didSet {
            var newFrame = frame
            guard newFrame.size.width != 53 || newFrame.size.height != 30 else { return }
            newFrame.size.width = 53
            newFrame.size.height = 30
            self.frame = newFrame
        }
    }
    
    // MARK: Initialization
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    
    private func commonInit() {
        setupViews()
        setupConstraints()
    }
    
    // MARK: Actions
    
    @objc
    private func tapped(_ sender: UITapGestureRecognizer) {
        isOn = !isOn
        generateFeedback()
    }
    
    private func generateFeedback() {
        let impactGenerator = UIImpactFeedbackGenerator(style: .light)
        impactGenerator.prepare()
        impactGenerator.impactOccurred()
    }
    
}

// MARK: View setup

private extension AppSwitch {
    func setupViews() {
        addSubview(nob)
        
        
        backgroundColor = offTintColor
        nob.backgroundColor = .white
        
        layer.cornerRadius = 15
        layer.masksToBounds = true
        
        nob.layer.cornerRadius = 11
        nob.layer.masksToBounds = true
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped)))
        
        nob.image = isOn ? onImage : offImage
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([heightAnchor.constraint(equalToConstant: 30),
        widthAnchor.constraint(equalToConstant: 53)])
        nob.frame = CGRect(x: 4, y: 4, width: 22, height: 22)
    }
}

// MARK: Animations

private extension AppSwitch {
    func animateChange() {
        isOn ? onAnimation() : offAnimation()
    }
    
    func onAnimation() {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: { [weak self] in
            
            guard let `self` = self else { return }
            self.animating = true
            self.backgroundColor = self.onTintColor
            self.nob.tintColor = self.onTintColor
            self.nob.image = self.onImage
            self.nob.frame = CGRect(x: self.bounds.width - self.nob.bounds.width - 4, y: self.nob.frame.origin.y, width: self.nob.bounds.width, height: self.nob.bounds.height)
            
            }, completion: { [weak self] completed in
                guard let `self` = self else { return }
                self.animating = !completed
        })
        
    }
    
    func offAnimation() {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: { [weak self] in
            
            guard let `self` = self else { return }
            
            self.backgroundColor = self.offTintColor
            self.nob.tintColor = self.offTintColor
            self.nob.image = self.offImage
            self.nob.frame = CGRect(x: 4, y: self.nob.frame.origin.y, width: self.nob.bounds.width, height: self.nob.bounds.height)
            
        }, completion: { [weak self] completed in
            guard let `self` = self else { return }
            self.animating = !completed
        })
    }
}

// MARK: Touch handling

extension AppSwitch {
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: self) else { return }
        touchStartLocation = location.x
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: self), !animating else { return }
        
        let difference = touchStartLocation - location.x
        
        if difference < -15  && !isOn {
            isOn = true
            generateFeedback()
        }
        if difference > 15 && isOn {
            isOn = false
            generateFeedback()
        }
    }
}
