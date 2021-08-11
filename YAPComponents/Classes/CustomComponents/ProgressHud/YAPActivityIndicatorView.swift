//
//  YAPActivityIndicatorView.swift
//  YAPKit
//
//  Created by Muhammad Hassan on 19/03/2020.
//  Copyright © 2020 YAP. All rights reserved.
//

import Foundation

class YAPActivityIndicatorView: UIView {
    
    override var layer: CAShapeLayer {
        get {
            return super.layer as! CAShapeLayer
        }
    }
    
    lazy var animationLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        return layer
    }()
    
    lazy var backgroundLayer: CAShapeLayer = {
        return CAShapeLayer()
    }()
    
    override class var layerClass: AnyClass {
        return CAShapeLayer.self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        animationLayer.fillColor = nil
        animationLayer.strokeColor = UIColor.primary.cgColor
        animationLayer.lineWidth = 4
        setPath()
    }
    
    override func didMoveToWindow() {
        DispatchQueue.main.async { [weak self] in
            self?.animate()
        }
    }
    
    private func setPath() {
        animationLayer.bounds = bounds
        backgroundLayer.bounds = bounds
        
        animationLayer.path = UIBezierPath(ovalIn: bounds.insetBy(dx: animationLayer.lineWidth / 2, dy: animationLayer.lineWidth / 2)).cgPath
        backgroundLayer.path = UIBezierPath(ovalIn: bounds.insetBy(dx: animationLayer.lineWidth / 2, dy: animationLayer.lineWidth / 2)).cgPath
        backgroundLayer.strokeColor = #colorLiteral(red: 0.9528579116, green: 0.9529946446, blue: 0.9528278708, alpha: 1)
        backgroundLayer.lineWidth = 4
        backgroundLayer.fillColor = nil
        self.layer.addSublayer(backgroundLayer)
        self.layer.addSublayer(animationLayer)
    }
    
    struct Pose {
        let secondsSincePriorPose: CFTimeInterval
        let start: CGFloat
        let length: CGFloat
        init(_ secondsSincePriorPose: CFTimeInterval, _ start: CGFloat, _ length: CGFloat) {
            self.secondsSincePriorPose = secondsSincePriorPose
            self.start = start
            self.length = length
        }
    }
    
    class var poses: [Pose] {
        get {
            return [
                Pose(0.0, 0.000, 0.7),
                               Pose(0.6, 0.500, 0.5),
                               Pose(0.6, 1.000, 0.3),
                               Pose(0.6, 1.500, 0.1),
                               Pose(0.2, 1.875, 0.1),
                               Pose(0.2, 2.250, 0.3),
                               Pose(0.2, 2.625, 0.5),
                               Pose(0.2, 3.000, 0.7),
//                Pose(0.0, 0.71, 0.08),
//                
//                // 2
//                Pose(0.5, 0.9, 0.2),
//                
//                // 3
//                Pose(0.11, 1.075, 0.35),
//                
//                // 4
//                Pose(0.2, 1.4, 0.2),
//                
//                // 5
//                Pose(0.5, 1.71, 0.08),
            ]
        }
    }
    
    func animate() {
        var time: CFTimeInterval = 0
        var times = [CFTimeInterval]()
        var start: CGFloat = 0
        var rotations = [CGFloat]()
        var strokeEnds = [CGFloat]()
        
        let poses = type(of: self).poses
        let totalSeconds = poses.reduce(0) { $0 + $1.secondsSincePriorPose }
        
        for pose in poses {
            time += pose.secondsSincePriorPose
            times.append(time / totalSeconds)
            start = pose.start
            rotations.append(start * 2 * .pi)
            strokeEnds.append(pose.length)
        }
        
        times.append(times.last!)
        rotations.append(rotations[0])
        strokeEnds.append(strokeEnds[0])
        
        animateKeyPath(keyPath: "strokeEnd", duration: totalSeconds, times: times, values: strokeEnds)
        animateKeyPath(keyPath: "transform.rotation", duration: totalSeconds, times: times, values: rotations)
    }
    
    func animateKeyPath(keyPath: String, duration: CFTimeInterval, times: [CFTimeInterval], values: [CGFloat]) {
        let animation = CAKeyframeAnimation(keyPath: keyPath)
        animation.keyTimes = times as [NSNumber]?
        animation.values = values
        animation.calculationMode = .linear
        animation.duration = duration
        animation.repeatCount = Float.infinity
        animationLayer.add(animation, forKey: animation.keyPath)
    }
}
