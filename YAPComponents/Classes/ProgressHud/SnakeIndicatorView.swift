//
//  SnakeIndicatorView.swift
//  YAPKit
//
//  Created by Zain on 27/06/2019.
//  Copyright © 2019 YAP. All rights reserved.
//

import UIKit

public class SnakeIndicatorView: UIView {
    
    // MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        self.backgroundColor = .clear
        let collectionView = UICollectionView(frame: bounds, collectionViewLayout: CircleLayout())
        addSubview(collectionView)
        collectionView.register(CircleCell.self, forCellWithReuseIdentifier: "CircleCell")
        collectionView.dataSource = self
        
        collectionView.performBatchUpdates(nil, completion: { (_) in
            let items = collectionView.numberOfItems(inSection: 0)
            let delay = 0.8/Double(items-1)
            for i in 0..<items {
                guard let cell = collectionView.cellForItem(at: IndexPath(item: i, section: 0)) as? CircleCell else { continue }
                cell.animate(withDelay: delay*Double(i))
            }
        })
    }
}

// MARK: Collection view data source

extension SnakeIndicatorView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "CircleCell", for: indexPath)
    }
}

// MARK: Collection view circular layout

private class CircleLayout: UICollectionViewLayout {
    
    private var center: CGPoint!
    private var itemSize: CGSize!
    private var radius: CGFloat!
    private var numberOfItems: Int!
    
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        
        center = CGPoint(x: collectionView.bounds.midX, y: collectionView.bounds.midY)
        let shortestAxisLength = min(collectionView.bounds.width, collectionView.bounds.height)
        itemSize = CGSize(width: shortestAxisLength * 0.2, height: shortestAxisLength * 0.2)
        radius = shortestAxisLength * 0.4
        numberOfItems = collectionView.numberOfItems(inSection: 0)
    }
    
    override var collectionViewContentSize: CGSize {
        return collectionView!.bounds.size
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        
        let angle = 2 * .pi * CGFloat(indexPath.item) / CGFloat(numberOfItems)
        
        attributes.center = CGPoint(x: center.x + radius * cos(angle), y: center.y + radius * sin(angle))
        attributes.size = itemSize
        
        return attributes
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return (0 ..< collectionView!.numberOfItems(inSection: 0))
            .compactMap { item -> UICollectionViewLayoutAttributes? in    // `flatMap` in Xcode versions prior to 9.3
                self.layoutAttributesForItem(at: IndexPath(item: item, section: 0))
        }
    }
}

// MARK: Circle cell for collection view

private class CircleCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.clipsToBounds = false
        clipsToBounds = false
        addDot()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let animationLayer = CAShapeLayer()
    
    private func addDot() {
        animationLayer.fillColor = UIColor.white.cgColor
        animationLayer.path = UIBezierPath.init(roundedRect: bounds, cornerRadius: bounds.size.height/2).cgPath
        animationLayer.contentsGravity = .center
        self.layer.addSublayer(animationLayer)
    }
    
    func animate(withDelay delay: Double) {
        animation.beginTime = CACurrentMediaTime() + delay
        animationLayer.add(animation, forKey: nil)
    }
    
    fileprivate lazy var animation: CAAnimationGroup = {
        let bounce = CABasicAnimation(keyPath: "transform.scale")
        bounce.toValue = 0.5
        
        let position = CABasicAnimation(keyPath: "position")
        position.toValue = CGPoint(x: bounds.size.width*0.25, y: bounds.size.height*0.25)
        
        let color = CABasicAnimation(keyPath: "fillColor")
        color.toValue = UIColor.black.cgColor
        
        let group = CAAnimationGroup()
        group.animations = [bounce, color, position]
        
        group.timingFunction = CAMediaTimingFunction(name: .linear)
        group.duration = 0.8
        group.repeatCount = .infinity
        //        group.autoreverses = true
        
        return group
    }()
}
