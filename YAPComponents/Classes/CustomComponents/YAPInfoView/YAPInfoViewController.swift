//
//  YAPInfoViewController.swift
//  YAPKit
//
//  Created by Zain on 07/10/2019.
//  Copyright © 2019 YAP. All rights reserved.
//

import UIKit

class YAPInfoViewController: UIViewController {
    
    // MARK: Views
    
    private lazy var infoViewBg: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var infoLabel: UILabel = UILabelFactory.createUILabel(with: .primaryDark, textStyle: .small, alignment: .left, numberOfLines: 0, lineBreakMode: .byWordWrapping)
    
    // MARK: Properties
    
    private var info: String!
    private var origin: CGPoint!
    var window: UIWindow?
    
    // MARK: Initialization
    
    init(info: String, origin: CGPoint) {
        super.init(nibName: nil, bundle: nil)
        
        self.info = info
        self.origin = origin
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: View cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        infoLabel.text = info
        
        setupViews()
        setupConstraints()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hide)))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        render()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
        
        show()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        view.window?.resignKey()
        view.window?.removeFromSuperview()
        window = nil
    }
    
    // MARK: Hide/Show
    
    @objc
    private func hide() {
        UIView.animate(withDuration: 0.3, animations: {
            self.infoViewBg.alpha = 0
        }) { (completed) in
            guard completed else { return }
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    private func show() {
        UIView.animate(withDuration: 0.3, animations: {
            self.infoViewBg.alpha = 1
        })
    }
}

// MARK: View setup

private extension YAPInfoViewController {
    func setupViews() {
        view.addSubview(infoViewBg)
        infoViewBg.addSubview(infoLabel)
    }
    
    func setupConstraints() {
        infoLabel
            .alignEdgesWithSuperview([.left, .top, .right, .bottom], constant: 12)
        
        infoViewBg
            .alignEdgesWithSuperview([.left, .right], .greaterThanOrEqualTo, constant: 25)
        
        infoViewBg
            .alignEdgeWithSuperview(.right, constant: UIScreen.main.bounds.width - origin.x)
            .pinEdge(.bottom, toEdge: .top, ofView: view, constant: -1 * origin.y)
        
    }
    
    func render() {
        infoViewBg.layer.cornerRadius = 12
        
        infoViewBg.layer.masksToBounds = false
        infoViewBg.layer.shadowColor = UIColor.black.cgColor
        infoViewBg.layer.shadowOffset = CGSize(width: 0, height: 0)
        infoViewBg.layer.shadowRadius = 10
        infoViewBg.layer.shadowOpacity = 0.2
    }
}
