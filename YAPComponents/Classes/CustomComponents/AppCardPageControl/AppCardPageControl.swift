//
//  AppCardPageControl.swift
//  YAPKit
//
//  Created by Zain on 07/01/2020.
//  Copyright © 2020 YAP. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

public class AppCardPageControl: UIControl {
    
    // MARK: Control properties
    
    public var currentPage: Int = 0 {
        didSet {
            (0..<buttonStack.arrangedSubviews.count).forEach{
                (buttonStack.arrangedSubviews[$0] as? PageControlButton)?.selectedCircle = $0 == currentPage
            }
        }
    }
    
    public var numberOfPages: Int = 0 {
        didSet {
            addPages()
        }
    }
    
    public var pageColors: [UIColor] = [] {
        didSet {
            pageColors.enumerated().forEach{
                guard $0.0 < buttonStack.arrangedSubviews.count else { return }
                (buttonStack.arrangedSubviews[$0.0] as? PageControlButton)?.color = $0.1
            }
        }
    }
    
    public var selectedColor: UIColor = .grey {
        didSet {
            buttonStack.arrangedSubviews.map{ $0 as? PageControlButton }.forEach{ $0?.selectedCircleColor = selectedColor }
        }
    }
    
    // MARK: Views
    
    private lazy var buttonStack: UIStackView = UIStackViewFactory.createStackView(with: .horizontal, alignment: .center, distribution: .fill, spacing: 10)
    
    // MARK: Initialization
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = .clear
        setupViews()
        setupConstraints()
    }
}

// MARK: Actions

private extension AppCardPageControl {
    @objc func buttonAction(_ sender: UIButton) {
        currentPage = sender.tag
        sendActions(for: .valueChanged)
    }
}

// MARK: View setup

public extension Reactive where Base: AppCardPageControl {
    var currentPage: ControlProperty<Int> {
        return base.rx.controlProperty(editingEvents: .valueChanged, getter: { pageControl in
            return pageControl.currentPage
        }) { (pageControl, currentPage) in
            pageControl.currentPage = currentPage
        }
    }
    
    var numberOfPages: Binder<Int> {
        return Binder(self.base) { pageControl, numberOfPage -> Void in
            pageControl.numberOfPages = numberOfPage
        }
    }
    
    var pageColors: Binder<[UIColor]> {
        return Binder(self.base) { pageControl, colors -> Void in
            pageControl.pageColors = colors
        }
    }
    
    var selectedRingColor: Binder<UIColor> {
        return Binder(self.base) { pageControl, color -> Void in
            pageControl.selectedColor = color
        }
    }
}

private extension AppCardPageControl {
    
    func setupViews() {
        addSubview(buttonStack)
    }
    
    func setupConstraints() {
        buttonStack
            .alignAllEdgesWithSuperview()
    }
    
    func addPages() {
        buttonStack.arrangedSubviews.forEach{ [weak self] in self?.buttonStack.removeArrangedSubview($0) }
        buttonStack.subviews.forEach{ $0.removeFromSuperview() }
        
        (0..<numberOfPages).forEach{
            let button = PageControlButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            buttonStack.addArrangedSubview(button)
            
            button.color = $0 < pageColors.count ? pageColors[$0] : .primary
            button.selectedCircleColor = selectedColor
            button.selectedCircle = $0 == currentPage
            button
                .width(with: .height, ofView: buttonStack)
                .height(with: .height, ofView: buttonStack)
            button.tag = $0
            button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        }
        
        layoutSubviews()
    }
}

// MARK: Reactive



fileprivate class PageControlButton: UIButton {
    
    // MARK: Control properties
    
    var selectedCircle: Bool = false {
        didSet {
            selectedView.isHidden = !selectedCircle
        }
    }
    
    var color: UIColor = .primary {
        didSet {
            background.backgroundColor = color
        }
    }
    
    var selectedCircleColor: UIColor = .grey {
        didSet {
            selectedView.layer.borderColor = selectedCircleColor.cgColor
        }
    }
    
    // MARK: Views
    
    private lazy var background: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var selectedView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = false
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        setupViews()
        setupConstraints()
    }
    
    // MARK: View cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        render()
        selectedView.layer.borderColor = selectedCircleColor.cgColor
        selectedView.layer.borderWidth = 2
    }
    
    
    // MARK: View setup
    
    private func setupViews() {
        addSubview(selectedView)
        addSubview(background)
    }
    
    private func setupConstraints() {
        background
            .centerInSuperView()
            .alignEdgesWithSuperview([.left, .top], constant: 4)
        
        selectedView
            .alignAllEdgesWithSuperview()
    }
    
    private func render() {
        background.roundView()
        selectedView.roundView()
    }
}


