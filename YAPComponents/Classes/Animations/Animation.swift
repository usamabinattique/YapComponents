//
//  Animation.swift
//  YAPKit
//
//  Created by Muhammad Hassan on 26/06/2019.
//  Copyright © 2019 YAP. All rights reserved.
//

import UIKit

/**
 A simple API to animate views in a more functional way.
 Credits: John Sundell
 */
public struct Animation {
    var duration: TimeInterval
    var delay: TimeInterval
    var springWithDamping: CGFloat
    var initialSpringVelocity: CGFloat
    var animationOption: UIView.AnimationOptions
    var closure: (UIView) -> Void
    
    init(duration: TimeInterval,
         delay: TimeInterval = 0,
         springWithDamping: CGFloat = 1,
         initialSpringVelocity: CGFloat = 0,
         animationOption: UIView.AnimationOptions = .init(),
         closure: @escaping (UIView) -> Void) {
        self.duration = duration
        self.delay = delay
        self.springWithDamping = springWithDamping
        self.initialSpringVelocity = initialSpringVelocity
        self.animationOption = animationOption
        self.closure = closure
    }
}

public extension Animation {
    static func fadeIn(duration: TimeInterval, delay: TimeInterval = 0, springWithDamping: CGFloat = 1) -> Animation {
        return Animation(duration: duration, delay: delay, springWithDamping: springWithDamping, closure: { $0.alpha = 1 })
    }
    
    static func scale(to scale: CGAffineTransform, delay: TimeInterval = 0, duration: TimeInterval, springWithDamping: CGFloat = 1, initialSpringVelocity: CGFloat = 0) -> Animation {
        return Animation(duration: duration, delay: delay, springWithDamping: springWithDamping, initialSpringVelocity: initialSpringVelocity, closure: { $0.transform = scale })
    }
    
    static func move(byX x: CGFloat, y: CGFloat, duration: TimeInterval) -> Animation {
        return Animation(duration: duration) {
            $0.center.x += x
            $0.center.y += y
        }
    }
    
    static func shake(duration: TimeInterval) -> Animation {
        return Animation(duration: duration, closure: { view in
            let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
            animation.repeatCount = 2
            animation.duration = duration/TimeInterval(animation.repeatCount)
            animation.autoreverses = true
            animation.values = [5, -5]
            view.layer.add(animation, forKey: "shake")
        })
    }
    
    static func bounce(duration: TimeInterval) -> Animation {
        return Animation(duration: duration, closure: { view in
            let animation = CABasicAnimation(keyPath: "transform")
            animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            animation.duration = duration
            animation.repeatCount = 2
            animation.autoreverses = true
            animation.isRemovedOnCompletion = true
            animation.toValue = NSValue(caTransform3D: CATransform3DMakeScale(1.1, 1.1, 1.0))
            view.layer.add(animation, forKey: nil)
        })
    }
}

public extension UIView {
    func animate(_ animations: [Animation]) {
        guard !animations.isEmpty else { return }
        
        var animations = animations
        let animation = animations.removeFirst()
        
        UIView.animate(withDuration: animation.duration, delay: animation.delay, options: animation.animationOption, animations: {
            animation.closure(self)
        }) { _ in
            self.animate(animations)
        }
    }
    
    func animate(inParallel animations: [Animation]) {
        for animation in animations {
            UIView.animate(withDuration: animation.duration, delay: animation.delay, usingSpringWithDamping: animation.springWithDamping, initialSpringVelocity: animation.initialSpringVelocity, options: animation.animationOption, animations: {
                animation.closure(self)
            })
        }
    }
    
    func animate(layerAnimation animations: [Animation]) {
        for animation in animations {
            animation.closure(self)
        }
    }
}

public extension Animation {
    static func slideIn(withDuration duration: TimeInterval,
                        delay: TimeInterval,
                        usingSpringWithDamping dampingRatio: CGFloat,
                        initialSpringVelocity velocity: CGFloat,
                        views: [UIView],
                        callback: @escaping () -> ()) {
        
        var delayChangeRate: TimeInterval = 0
        
        for (index, view) in views.enumerated() {
            delayChangeRate += index > 0 ? (delay / TimeInterval(index * 2)) : 0
            let animation = Animation(duration: duration, delay: delayChangeRate, springWithDamping: dampingRatio, initialSpringVelocity: velocity, animationOption: .curveEaseOut) { (view) in
                view.transform = CGAffineTransform(translationX: 0, y: 0)
                view.alpha = 1
                callback()
            }
            
            view.animate(inParallel: [animation])
        }
    }
}
