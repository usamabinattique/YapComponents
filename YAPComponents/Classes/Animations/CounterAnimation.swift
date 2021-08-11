//
//  CounterAnimation.swift
//  YAPKit
//
//  Created by Zain on 03/07/2019.
//  Copyright © 2019 YAP. All rights reserved.
//

import Foundation

public extension UILabel {
    
    /// UILabel must have attributedText set. Otherwise animation won't run
    ///
    /// - Parameters:
    ///   labels: Array of strings to be animated
    ///   duration: TimeInterval to complete animation
    ///   range: Range of text in string to be animated
    ///
    /// - Returns:
    ///   none
    func animateCountDown(labels: [String], withDuration duration: TimeInterval, inRange range: NSRange) {
        
        guard var rect = boundingRect(forCharacterRange: range) else { return }
        guard let attributes = attributedText?.attributes(at: range.location, effectiveRange: nil) else { return }
        
//        print(UIScreen.main.bounds.width)
        let padding: CGFloat = UIScreen.main.bounds.width > 400 ? 148 : 98
        rect.origin = CGPoint(x: rect.origin.x + padding, y: rect.origin.y)
        let view = UIView(frame: rect)
        view.clipsToBounds = true
        addSubview(view)
        
        let label = UILabel(frame: view.bounds)
        view.addSubview(label)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = attributes.filter { $0.key == NSAttributedString.Key.font }.first?.value as? UIFont
        label.textColor = attributes.filter { $0.key == NSAttributedString.Key.foregroundColor }.first?.value as? UIColor
        label.textAlignment = textAlignment
        
        let singleAnimationDuration = duration / TimeInterval(labels.count)

        label.animate(atIndex: 0, labels: labels, interval: singleAnimationDuration, completion: nil)
        
        let text = NSMutableAttributedString(attributedString: attributedText!)
        text.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.clear, range: range)
        attributedText = text
        
    }
    
    private func animate(atIndex index: Int, labels: [String], interval: CFTimeInterval, completion: (() -> ())?) {
        moveUpTransition(interval)
        text = labels[index]
        
        guard index+1 < labels.count else {
            if let completion = completion {
                completion()
            }
           
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+interval) { [weak self] in
            self?.animate(atIndex: index+1, labels: labels, interval: interval, completion: completion)
        }
    }
    
    private func boundingRect(forCharacterRange range: NSRange) -> CGRect? {
        
        guard let attributedText = attributedText else { return nil }
        
        let textStorage = NSTextStorage(attributedString: attributedText)
        let layoutManager = NSLayoutManager()
        
        textStorage.addLayoutManager(layoutManager)
        let textContainer = NSTextContainer(size: intrinsicContentSize)
        textContainer.lineFragmentPadding = 0.0
        layoutManager.addTextContainer(textContainer)
        var glyphRange = NSRange()
        layoutManager.characterRange(forGlyphRange: range, actualGlyphRange: &glyphRange)
        
        return layoutManager.boundingRect(forGlyphRange: glyphRange, in: textContainer)
    }
    
}

fileprivate extension UIView {
    func moveUpTransition(_ duration: CFTimeInterval) {
        
        let moveAnimation: CATransition = CATransition()
        moveAnimation.type = CATransitionType.push
        moveAnimation.subtype = CATransitionSubtype.fromTop
        moveAnimation.timingFunction = CAMediaTimingFunction(name:
            CAMediaTimingFunctionName.linear)
        moveAnimation.duration = duration
        
        layer.masksToBounds = true
        layer.add(moveAnimation, forKey: CATransitionType.push.rawValue)
    }
    
    func moveDownTransition(_ duration: CFTimeInterval) {
        
        let moveAnimation: CATransition = CATransition()
        moveAnimation.type = CATransitionType.push
        moveAnimation.subtype = CATransitionSubtype.fromBottom
        moveAnimation.timingFunction = CAMediaTimingFunction(name:
            CAMediaTimingFunctionName.linear)
        moveAnimation.duration = duration
        
        layer.masksToBounds = true
        layer.add(moveAnimation, forKey: CATransitionType.push.rawValue)
    }
}

public extension UILabel {
    func animate(atIndex index: Int, labels: [String], interval: CFTimeInterval, bounce: Bool = true) {
        
        animate(atIndex: index, labels: labels, interval: interval, completion: ({
            if bounce {
                DispatchQueue.main.asyncAfter(deadline: .now()+interval) { [weak self] in
                    self?.moveDownTransition(interval)
                    /// last element is extra for bounce effect, that's why we are using 2nd last element.
                    self?.text = labels[labels.count - 2]
                }
            }
        }))
    }
}

//DispatchQueue.main.asyncAfter(deadline: .now()+interval) { [weak self] in
//                   // let animation = Animation.bounce(duration: interval)
//                    let ann = Animation.move(byX: 0, y: -(self?.bounds.height ?? 0/2 ), duration: interval/2)
//                    let ann1 = Animation.move(byX: 0, y: (self?.bounds.height ?? 0/2), duration: interval/2)
//                   // let ann2 = Animation.move(byX: 0, y: -(self?.bounds.height ?? 0/2 ), duration: interval/3)
//                    self?.animate([ann, ann1 ])
//                }

