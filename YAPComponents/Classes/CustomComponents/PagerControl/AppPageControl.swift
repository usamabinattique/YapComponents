//
//  AppPageControl.swift
//  YAPKit
//
//  Created by Zain on 18/06/2019.
//  Copyright © 2019 YAP. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

open class AppPageControl: UIView {
    
    public var pages: Int = 0 {
        didSet {
            addDots()
        }
    }

    fileprivate let selectedPageSubject = PublishSubject<Int>()
    private let disposeBag = DisposeBag()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var dots = [Dot]()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        
        setupViews()
        setupConstraints()
        
        selectedPageSubject.subscribe(onNext: { [unowned self] page in
            self.setPageSelected(UInt(page))
        }).disposed(by: disposeBag)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func setPageSelected(_ page: UInt) {
        guard page < pages else { return }
        for i in 0..<pages {
            if i == page, !dots[i].selected {
                dots[i].setSelected(true)
            }
            if i != page, dots[i].selected {
                dots[i].setSelected(false)
            }
        }
    }
    
}

// MARK: View setup

extension AppPageControl {
    fileprivate func setupViews() {
        addSubview(stackView)
    }
    
    fileprivate func addDots() {
        dots.removeAll()
        for i in 0..<pages {
            let dot = Dot()
            dot.selected = i == 0
            stackView.addArrangedSubview(dot)
            dots.append(dot)
            dot.width(constant: 12).height(constant: 12)
        }
    }
    
    fileprivate func setupConstraints() {
        
        stackView.alignEdgesWithSuperview([.left, .right, .top, .bottom])
        
        for dot in dots {
            dot.width(constant: 12).height(constant: 12)
        }
    }
}

// MARK: Rx

extension Reactive where Base: AppPageControl {
    public var selectedPage: AnyObserver<Int> {
        return self.base.selectedPageSubject.asObserver()
    }
}

// MARK: Dot

private class Dot: UIView {
    
    private let dotLayer = CAShapeLayer()
    
    private let largeDotRatio: CGFloat = 1
    private let smallDotRatio: CGFloat = 0.667
    
    private var smallPath: UIBezierPath?
    private var largePath: UIBezierPath?
    
    fileprivate var selectedColor = UIColor.appColor(ofType: .primary)
    fileprivate var unselectedColor = UIColor.appColor(ofType: .greyLight)
    fileprivate var selected = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.addSublayer(dotLayer)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        dotLayer.frame = rect
        dotLayer.fillColor = selected ? selectedColor.cgColor : unselectedColor.cgColor
        dotLayer.path = selected ? pathForLargeDot(inRect: rect).cgPath : pathForSmallDot(inRect: rect).cgPath
        dotLayer.rasterizationScale = UIScreen.main.scale
        dotLayer.shouldRasterize = true
        
        smallPath = pathForSmallDot(inRect: rect)
        largePath = pathForLargeDot(inRect: rect)
    }
}

extension Dot {
    fileprivate func pathForLargeDot(inRect rect: CGRect) -> UIBezierPath {
        let rect = rect.scaleAndCenter(withRatio: largeDotRatio)
        let path = UIBezierPath(roundedRect: rect, cornerRadius: rect.size.height/2)
        
        return path
    }
    
    fileprivate func pathForSmallDot(inRect rect: CGRect) -> UIBezierPath {
        let rect = rect.scaleAndCenter(withRatio: smallDotRatio)
        let path = UIBezierPath(roundedRect: rect, cornerRadius: rect.size.height/2)
        
        return path
    }
    
    fileprivate func setSelected(_ selected: Bool) {
        guard let `largePath` = largePath, let `smallPath` = smallPath else { return }
        self.selected = selected
        let pathAnimation = CABasicAnimation(keyPath: "path")
        pathAnimation.toValue = selected ? largePath.cgPath : smallPath.cgPath
        pathAnimation.duration = 0.25
        pathAnimation.fillMode = .forwards
        pathAnimation.isRemovedOnCompletion = false
        
        let colorAnimation = CABasicAnimation(keyPath: "fillColor")
        colorAnimation.toValue = selected ? selectedColor.cgColor : unselectedColor.cgColor
        colorAnimation.isRemovedOnCompletion = false
        colorAnimation.duration = 0.25
        colorAnimation.fillMode = .forwards
        
        dotLayer.add(pathAnimation, forKey: nil)
        dotLayer.add(colorAnimation, forKey: nil)
    }
}

fileprivate extension CGRect {
    
    /// Returns a new `CGRect` instance scaled up or down, with the same center as the original `CGRect` instance.
    /// - Parameters:
    ///   - ratio: The ratio to scale the `CGRect` instance by.
    /// - Returns: A new instance of `CGRect` scaled by the given ratio and centered with the original rect.
    func scaleAndCenter(withRatio ratio: CGFloat) -> CGRect {
        let scaleTransform = CGAffineTransform(scaleX: ratio, y: ratio)
        let scaledRect = applying(scaleTransform)
        
        let translateTransform = CGAffineTransform(translationX: origin.x * (1 - ratio) + (width - scaledRect.width) / 2.0, y: origin.y * (1 - ratio) + (height - scaledRect.height) / 2.0)
        let translatedRect = scaledRect.applying(translateTransform)
        
        return translatedRect
    }
}
