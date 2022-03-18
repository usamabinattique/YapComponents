//
//  YapInfoView.swift
//  YAPComponents
//
//  Created by Yasir on 17/03/2022.
//

import UIKit

public class YAPInfoView {
    
    // MARK: Properties
    
    let viewController: YAPInfoViewController!
    
    // MARK: Initialization
    
    public init(info: String, origin: CGPoint, infoLabel: UILabel) {
        viewController = YAPInfoViewController(info: info, origin: origin, infoLabel: infoLabel)
    }
    
}

// MARK: Public methods

public extension YAPInfoView {
    
    func show() {
        
        UIApplication.shared.windows.filter{ $0.tag == 0xdead }.forEach {
            $0.rootViewController?.dismiss(animated: false, completion: nil)
            $0.removeFromSuperview()
        }
        
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        
        alertWindow.rootViewController = YAPInfoViewRootViewController(nibName: nil, bundle: nil)
        alertWindow.backgroundColor = .clear
        alertWindow.windowLevel = .alert + 1
        alertWindow.isHidden = false
        alertWindow.tag = 0xdead
        
        let nav = UINavigationController(rootViewController: viewController)
        nav.navigationBar.isHidden = true
        nav.modalPresentationStyle = .overCurrentContext
        
        alertWindow.rootViewController?.present(nav, animated: false, completion: nil)
        
        viewController.window = alertWindow
    }
}

// MARK: Root View controller

private class YAPInfoViewRootViewController: UIViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return UIApplication.shared.statusBarStyle
        }
    }
}

// MARK: Developer convenience methods

public extension YAPInfoView {
    static func show(info: String, fromView view: UIView, infoLabel: UILabel) {
        var origin = view.superview?.convert(view.frame.origin, to: nil) ?? .zero
        
        origin.x = origin.x + view.bounds.width
        origin.y -= 15
        
        YAPInfoView(info: info, origin: origin, infoLabel: infoLabel).show()
    }
}

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
    
    private lazy var infoLabel: UILabel = {
        return _infoLabel
    }() //UILabelFactory.createUILabel(with: .primaryDark, textStyle: .small, alignment: .left, numberOfLines: 0, lineBreakMode: .byWordWrapping)
    
    // MARK: Properties
    
    private var info: String!
    private var origin: CGPoint!
    var window: UIWindow?
    private var _infoLabel: UILabel
    
    // MARK: Initialization
    
    init(info: String, origin: CGPoint, infoLabel: UILabel) {
        
        
        self.info = info
        self.origin = origin
        self._infoLabel = infoLabel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
