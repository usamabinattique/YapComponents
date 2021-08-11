//
//  DashboardToolbar.swift
//  YAPKit
//
//  Created by Zain on 26/08/2019.
//  Copyright © 2019 YAP. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public class HomeBalanceToolbar: UIView {
    
    fileprivate lazy var searchButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage.sharedImage(named: "icon_search")?.withRenderingMode(.alwaysTemplate), for:
            .normal)
        button.tintColor = .primary
        button.isHidden = true
        return button
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.isPagingEnabled = true
        scrollView.clipsToBounds = false
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private var views = [HomeBalanceView]()
    
    public var maxHeight: CGFloat = 120
    private(set) public var minHeight: CGFloat = 60
    private var height: NSLayoutConstraint!
    private var currentHeight: CGFloat = 0
    
    fileprivate let scrollingSubject = PublishSubject<Bool>()
    fileprivate let indexSubject = PublishSubject<Int>()
    
    // MARK: Initialization
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        translatesAutoresizingMaskIntoConstraints = false
        setupViews()
        setupConstraints()
        isUserInteractionEnabled = true
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped(_:))))
    }
    
    public var currentIndex: Int {
        return views.filter { $0.visible }.first?.tag ?? 0
    }
    
    public func changeThemeColor(to color: UIColor) {
        searchButton.tintColor = color
        for view in views {
            view.changeThemeColor(to: color)
        }
    }
    
    // MAKR: Layouting
    
    public override func layoutIfNeeded() {
        super.layoutIfNeeded()
        scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: scrollView.bounds.height)
    }
    
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        guard view == self, let subView = view?.subviews.first else { return view }
        return subView
    }
    
    // MARK: Tap action
    
    @objc
    func tapped(_ tapGesture: UITapGestureRecognizer) {
        let point = tapGesture.location(in: self)
        guard point.x < scrollView.frame.origin.x || point.x > scrollView.frame.origin.x + scrollView.bounds.width else { return }
        
        let isLeft = point.x < scrollView.frame.origin.x
        let currentIndex = self.currentIndex
        
        guard !isLeft || currentIndex > 0 else { return }
        guard isLeft || currentIndex < views.count-1 else { return }
        
        let offsetX = isLeft ? -1 * scrollView.bounds.width : scrollView.bounds.width
        
        scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x + offsetX, y: 0), animated: true)
    }
}

// MARK: View setup

private extension HomeBalanceToolbar {
    func setupViews() {
        addSubview(scrollView)
        addSubview(searchButton)
    }
    
    func setupConstraints() {
        
        scrollView
            .alignEdgesWithSuperview([.top, .bottom], constants: [25, 0])
            .centerHorizontallyInSuperview()
            .width(constant: UIScreen.main.bounds.width*0.5)
        
        height = heightAnchor.constraint(equalToConstant: maxHeight)
        height.isActive = true
        
        searchButton
            .alignEdgeWithSuperview(.left, constant: 20)
            .alignEdge(.top, withView: scrollView, constant: -5)
            .width(constant: 26)
            .height(constant: 26)
    }
}

// MARK: Scroll view delegate

extension HomeBalanceToolbar: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.x
        guard offset >= 0 && offset <= scrollView.contentSize.width else { return }
        _ = views.map { $0.setScrollOffset(offset) }
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollingSubject.onNext(true)
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollingSubject.onNext(false)
    }
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        indexSubject.onNext(currentIndex)
    }
}

// MARK: Data Control

public extension HomeBalanceToolbar {
    
    func setData(_ balance: [Balance]) {
        
        _ = scrollView.subviews.map { $0.removeFromSuperview() }
        views.removeAll()
        
        for i in 0..<balance.count {
            let view = HomeBalanceView()
            view.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview(view)
            views.append(view)
            view.tag = i
            view.dashboardCurrency = balance[i]
        }
        
        var prevView: UIView?
        
        for view in views {
            view
                .alignEdgesWithSuperview([.top, .bottom])
                .height(with: .height, ofView: scrollView)
                .width(with: .width, ofView: scrollView)
            
            if prevView == nil {
                view.alignEdgeWithSuperview(.left)
            } else {
                view.toRightOf(prevView!)
            }
            prevView = view
        }
        
        prevView?.alignEdgeWithSuperview(.right)
        changeHeight(by: currentHeight)
    }
    
    func changeHeight(by height: CGFloat) {
        currentHeight = height
        guard height >= 0, views.count > 0 else { return }
        
        scrollView.isScrollEnabled = height >= 1
        
        self.height.constant = minHeight + ((maxHeight - minHeight) * (height > 1 ? 1 : height))
        
        let currentIndex = self.currentIndex
        
        let currentView = views[currentIndex]
        let leftView = currentIndex == 0 ? nil : views[currentIndex - 1]
        let rightView = currentIndex == views.count - 1 ? nil : views[currentIndex + 1]
        
        currentView.changeHeight(by: height)
        leftView?.moveLeft(by: height)
        rightView?.moveRight(by: height)
    }
}

// MARK: Reactive

public extension Reactive where Base: HomeBalanceToolbar {
    var scrolling: Observable<Bool> {
        return self.base.scrollingSubject.asObservable()
    }
    
    var data: Binder<[Balance]> {
        return Binder(self.base) { toolbar, data in
            toolbar.setData(data)
        }
    }
    
    var selectedIndex: Observable<Int> {
        return self.base.indexSubject.asObservable()
    }
    
    var searchTap: ControlEvent<Void> {
        return self.base.searchButton.rx.tap
    }
}
