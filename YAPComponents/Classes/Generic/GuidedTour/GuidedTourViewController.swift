//
//  GuidedTourViewController.swift
//  YAP
//
//  Created by Muhammad Awais on 17/03/2020.
//  Copyright © 2020 YAP. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class GuidedTourViewController: UIViewController {
    
    // MARK: - Init
    
    public init(viewModel: GuidedTourViewModelType) {
        self.viewModel = viewModel
        disposeBag = DisposeBag()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Properties
    let viewModel: GuidedTourViewModelType
    let disposeBag: DisposeBag
    
    
    var overlayContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var guidedTourDetailView: GuidedTourDetailView = {
        let view = GuidedTourDetailView(frame: CGRect.zero)
        view.arrowXPoint = 50
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    lazy var skipActionButton: AppRoundedButton = {
        let button = AppRoundedButtonFactory.createAppRoundedButton()
        button.titleLabel?.font =  .appFont(forTextStyle: .small)
        button.translatesAutoresizingMaskIntoConstraints = true
        button.title = "Skip tutorial"
        button.setTitleColor(UIColor.init(red: 94/255, green: 53/255, blue: 177/255, alpha: 1), for: .normal)
        button.backgroundColor = UIColor.white
        return button
    }()
    
    var overlayView: UIView = {
        let view = UIView()
        return view
    }()

    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
        bind()
        viewModel.inputs.viewDidLoadObserver.onNext(())
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

}

// MARK: View setup
private extension GuidedTourViewController {
    func setup() {
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        view.backgroundColor = UIColor.clear
        view.addSubview(overlayContainerView)
        view.addSubview(guidedTourDetailView)
        view.addSubview(skipActionButton)
    }
    
    func setupConstraints() {
        overlayContainerView
            .alignEdgesWithSuperview([.left, .right, .top, .bottom], constants: [0, 0, 0, 0])
        guidedTourDetailView.frame = CGRect(x: 25, y: 0, width: self.view.frame.size.width-50, height: 165)
    }
    
    @objc
    private func showNextGuidedTour() {
        viewModel.inputs.nextGuidedTourObserver.onNext(())
    }
}

// MARK: - Bind
private extension GuidedTourViewController {
    func bind() {
        guidedTourDetailView.nextActionViewButton.addTarget(self, action: #selector(showNextGuidedTour), for: .touchUpInside)
        skipActionButton.rx.tap.bind(to: viewModel.inputs.skipObserver).disposed(by: disposeBag)
        viewModel.outputs.guidedTourTitle.bind(to: guidedTourDetailView.rx.title).disposed(by: disposeBag)
        viewModel.outputs.guidedTourDescription.bind(to: guidedTourDetailView.rx.description).disposed(by: disposeBag)
        viewModel.outputs.guidedTourNextButtonTitle.bind(to: guidedTourDetailView.rx.nextButtonTitle).disposed(by: disposeBag)
        viewModel.outputs.guidedTourStepsTitle.bind(to: guidedTourDetailView.rx.stepLabelText).disposed(by: disposeBag)
        viewModel.outputs.hideSkip.bind(to: skipActionButton.rx.isHidden).disposed(by: disposeBag)
        
        viewModel.outputs.currentGuidedTourCircle.subscribe(onNext: { [weak self] guidedTourCirlce in
            DispatchQueue.main.async {
                self?.overlayView.removeFromSuperview()
                guard let circle = guidedTourCirlce, let centerX = circle.centerPointX, let centerY = circle.centerPointY, let radius = circle.radius, let type = circle.viewType else {
                    return
                }
                if let strongSelf = self {
                    strongSelf.overlayView = strongSelf.createOverlay(frame: strongSelf.view.frame, xOffset: CGFloat(centerX), yOffset: CGFloat(centerY), radius: CGFloat(radius), type: type)
                    strongSelf.overlayContainerView.addSubview(strongSelf.overlayView)
                }
                guard let popOverType = self?.calculateDetailViewAlignment(guidedTourCircle: circle), let arrowXPoint = self?.calculateArrowXpoint(guidedTourCircle: circle) else {
                    return
                }
                self?.updateSkipTutorialPosition(popOverType: popOverType)
                self?.guidedTourDetailView.popoverType = popOverType
                self?.guidedTourDetailView.arrowXPoint = arrowXPoint
                var constant: CGFloat = 0
                if popOverType == .down {
                    var guidedDetailViewFrame = self?.guidedTourDetailView.frame
                    if let strongSelf = self {
                        let descriptionLabelHeight = strongSelf.guidedTourDetailView.guidedTourDetailLabel.text?.height(withConstrainedWidth: strongSelf.guidedTourDetailView.bounds.width-60, font: strongSelf.guidedTourDetailView.guidedTourDetailLabel.font)
                        guidedDetailViewFrame?.size.height = 109 + (descriptionLabelHeight ?? strongSelf.guidedTourDetailView.guidedTourDetailLabel.bounds.size.height)
                        strongSelf.guidedTourDetailView.detailLabelHeight = descriptionLabelHeight
                    }
                    let guidedTourViewHeight = Int(guidedDetailViewFrame?.size.height ?? 165)
                    
                    constant = CGFloat(Int(centerY) - radius - 20 - guidedTourViewHeight)
                    guidedDetailViewFrame?.origin.y = constant
                    UIView.animate(withDuration: 0.4) {
                        self?.guidedTourDetailView.frame = guidedDetailViewFrame ?? CGRect.zero
                    }
                } else {
                    constant = CGFloat(Int(centerY) + radius + 20)
                    var guidedDetailViewFrame = self?.guidedTourDetailView.frame
                    if let strongSelf = self {
                        let descriptionLabelHeight = strongSelf.guidedTourDetailView.guidedTourDetailLabel.text?.height(withConstrainedWidth: strongSelf.guidedTourDetailView.bounds.width-60, font: strongSelf.guidedTourDetailView.guidedTourDetailLabel.font)
                        guidedDetailViewFrame?.size.height = 111 + (descriptionLabelHeight ?? strongSelf.guidedTourDetailView.guidedTourDetailLabel.bounds.size.height)
                        strongSelf.guidedTourDetailView.detailLabelHeight = descriptionLabelHeight
                    }
                    guidedDetailViewFrame?.origin.y = constant
                    UIView.animate(withDuration: 0.4) {
                        self?.guidedTourDetailView.frame = guidedDetailViewFrame ?? CGRect.zero
                    }
                }
                self?.guidedTourDetailView.setNeedsDisplay()
            }
            }, onCompleted: { [weak self] in
                DispatchQueue.main.async {
                    self?.dismiss(animated: false, completion: nil)
                }
        }).disposed(by: disposeBag)
    }
    
    func createOverlay(frame: CGRect,
                       xOffset: CGFloat,
                       yOffset: CGFloat,
                       radius: CGFloat, type: drawType = .circle) -> UIView {
        let overlayView = UIView(frame: frame)
        overlayView.backgroundColor = UIColor.init(red: 39/255, green: 34/255, blue: 98/255, alpha: 0.32)
        let path = CGMutablePath()
        if type == .circle {
            path.addArc(center: CGPoint(x: xOffset, y: yOffset),
            radius: radius,
            startAngle: 0.0,
            endAngle: 2.0 * .pi,
            clockwise: false)
        } else {
            path.addRect(CGRect(x: 0, y: yOffset-radius, width: self.view.frame.size.width, height: radius*2))
        }
        path.addRect(CGRect(origin: .zero, size: overlayView.frame.size))
        let maskLayer = CAShapeLayer()
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.path = path
        maskLayer.fillRule = .evenOdd
        overlayView.layer.mask = maskLayer
        overlayView.clipsToBounds = true
        return overlayView
    }
}

private extension GuidedTourViewController {
    
    private func calculateDetailViewAlignment(guidedTourCircle: GuidedCircle) -> PopoverType? {
        guard let centerY = guidedTourCircle.centerPointY else {
            return nil
        }
        //Check if points are center of screen
        if CGFloat(centerY) < view.frame.midY+1 {
            return .up
        }
        return .down
    }
    
    private func calculateArrowXpoint(guidedTourCircle: GuidedCircle) -> CGFloat? {
        guard let centerX = guidedTourCircle.centerPointX else {
            return nil
        }
        if CGFloat(centerX) < 45  {
            return 45
        } else if CGFloat(centerX) > (view.frame.maxX - 90) {
            return CGFloat(view.frame.maxX - 90)
        }
        return CGFloat(centerX - 28)
    }
    
    private func updateSkipTutorialPosition(popOverType: PopoverType) {
        let width = view.bounds.width
        let height = view.bounds.height
        let buttonWidth: CGFloat = 116
        let buttonHeight: CGFloat = 32
        let x = width - buttonWidth - 20
        var y: CGFloat = 52
        if popOverType == .up {
            y = height - buttonHeight - 55
        }
        skipActionButton.frame = CGRect(x: x, y: y, width: buttonWidth, height: buttonHeight)
    }
}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(boundingBox.height)
    }
}
