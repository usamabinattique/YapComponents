//
//  GuidedTourDetailView.swift
//  YAP
//
//  Created by Muhammad Awais on 19/03/2020.
//  Copyright © 2020 YAP. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

enum PopoverType: Int {
    case up
    case down
}

class GuidedTourDetailView: UIView {
    
    lazy var nextActionViewButton: AppRoundedButton = {
        let button = AppRoundedButtonFactory.createAppRoundedButton()
        button.titleLabel?.font =  .appFont(forTextStyle: .small)
        button.translatesAutoresizingMaskIntoConstraints = true
        button.title = "Next"
        return button
    }()
    
    lazy var guidedTourTitleLabel: UILabel = {
        let label = UILabelFactory.createUILabel(with: .primaryDark, textStyle: .micro, alignment: .left)
        label.translatesAutoresizingMaskIntoConstraints = true
        return label
    }()
    
    lazy var guidedTourDetailLabel: UILabel = {
        let label = UILabelFactory.createUILabel(with: .greyDark, textStyle: .micro, alignment: .left)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = true
        label.textAlignment = .left
        return label
    }()
    
    lazy var guidedTourStepsLabel: UILabel = {
        let label = UILabelFactory.createUILabel(with: .primary, textStyle: .micro, alignment: .right)
        label.numberOfLines = 1
        label.text = "4/5"
        label.translatesAutoresizingMaskIntoConstraints = true
        return label
    }()
    
    var arrowSize: CGSize = CGSize(width: 30, height: 20.0)
    var cornerRadius: CGFloat = 6.0
    var popoverType: PopoverType = .down
    var borderColor: UIColor?
    var detailLabelHeight: CGFloat?
    var arrowXPoint: CGFloat!
    
    let nextButtonWidth: CGFloat = 120.0
    let nextButtonHeight: CGFloat = 32
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let width: CGFloat = rect.width
        let height: CGFloat = rect.height
        
        let radius: CGFloat = 8
        let arrowRadius: CGFloat = 4
        
        let arrowWidth: CGFloat = 24
        let arrowHeight: CGFloat = 15
        
        let path: UIBezierPath = UIBezierPath()
        
        if popoverType == .up {
            let startingPoint = CGPoint(x: radius, y: height)
            let upperRightCenter = CGPoint(x: width - radius, y:  radius + arrowHeight)
            let bottomRightCenter = CGPoint(x: width - radius, y: height - radius)
            let bottomLeftCenter = CGPoint(x: radius, y: height - radius)
            let upperLeftCenter = CGPoint(x: radius, y: arrowHeight + radius)
            
            path.move(to: startingPoint)
            
            path.addArc(withCenter: bottomRightCenter, radius: radius, startAngle: 90.degreesToRadians, endAngle: 270, clockwise: false)
            
            path.addArc(withCenter: upperRightCenter, radius: radius, startAngle: 0, endAngle: 270.degreesToRadians, clockwise: false)
            
            path.addArc(withCenter: CGPoint(x: (arrowXPoint + arrowWidth/2) + arrowRadius, y: arrowHeight - arrowRadius), radius: arrowRadius, startAngle: 90.degreesToRadians, endAngle: 135.degreesToRadians, clockwise: true)
            
            path.addArc(withCenter: CGPoint(x: arrowXPoint, y: arrowRadius), radius: arrowRadius, startAngle: 315.degreesToRadians, endAngle: 225.degreesToRadians, clockwise: false)
            
            path.addArc(withCenter: CGPoint(x: (arrowXPoint - arrowWidth/2 - arrowRadius), y: arrowHeight - arrowRadius), radius: arrowRadius, startAngle: 45.degreesToRadians, endAngle: 90.degreesToRadians, clockwise: true)
            
            path.addArc(withCenter: upperLeftCenter, radius: radius, startAngle: 270.degreesToRadians, endAngle: 180.degreesToRadians, clockwise: false)
            
            path.addArc(withCenter: bottomLeftCenter, radius: radius, startAngle: 180.degreesToRadians, endAngle: 45, clockwise: false)
            
        } else {
            let startingPoint = CGPoint(x: radius, y: 0)
                   let upperRightCenter = CGPoint(x: width - radius, y: radius)
                   let bottomRightCenter = CGPoint(x: width - radius, y: height - radius - arrowHeight)
                   let bottomLeftCenter = CGPoint(x: radius, y: height - radius - arrowHeight)
                   let upperLeftCenter = CGPoint(x: radius, y: radius)
                   
                   path.move(to: startingPoint)
                   
                   path.addArc(withCenter: upperRightCenter, radius: radius, startAngle: 270.degreesToRadians, endAngle: 0, clockwise: true)
                   
                   path.addArc(withCenter: bottomRightCenter, radius: radius, startAngle: 0, endAngle: 90.degreesToRadians, clockwise: true)
                   
                   path.addArc(withCenter: CGPoint(x: (arrowXPoint + arrowWidth/2) + arrowRadius, y: height + arrowRadius - arrowHeight), radius: arrowRadius, startAngle: 270.degreesToRadians, endAngle: 225.degreesToRadians, clockwise: false)
                   
                   path.addArc(withCenter: CGPoint(x: arrowXPoint, y: height - arrowRadius), radius: arrowRadius, startAngle: 45.degreesToRadians, endAngle: 135.degreesToRadians, clockwise: true)
                   
                   path.addArc(withCenter: CGPoint(x: (arrowXPoint - arrowWidth/2 - arrowRadius), y: height + arrowRadius - arrowHeight), radius: arrowRadius, startAngle: 315.degreesToRadians, endAngle: 270.degreesToRadians, clockwise: false)
                   
                   path.addArc(withCenter: bottomLeftCenter, radius: radius, startAngle: 90.degreesToRadians, endAngle: 180.degreesToRadians, clockwise: true)
                   
                   path.addArc(withCenter: upperLeftCenter, radius: radius, startAngle: 180.degreesToRadians, endAngle: 270.degreesToRadians, clockwise: true)
        }
        
        path.close()
        path.lineWidth = 1
        UIColor.white.setFill()
        UIColor.init(red: 147/255, green: 145/255, blue: 177/255, alpha: 0.12).setStroke()
        
        path.fill()
        path.stroke()
    
        updateGuidedViewConstraint(popOverType: popoverType)
    }
}

extension Int {
    var degreesToRadians: CGFloat {
        return CGFloat(Double.pi) * CGFloat(self) / 180.0
    }
}

fileprivate extension GuidedTourDetailView {
    private func setupViews() {
        self.addSubview(guidedTourTitleLabel)
        self.addSubview(nextActionViewButton)
        self.addSubview(guidedTourDetailLabel)
        self.addSubview(guidedTourStepsLabel)
    }
    private func updateGuidedViewConstraint(popOverType: PopoverType) {
        switch popOverType {
        case .up:
            var titleFrame = guidedTourTitleLabel.frame
            titleFrame.origin.x = 20
            titleFrame.origin.y = 31
            titleFrame.size.width = self.bounds.size.width - 60
            titleFrame.size.height = 16
            guidedTourTitleLabel.frame = titleFrame
            
            var stepsFrame = guidedTourStepsLabel.frame
            stepsFrame.origin.x = self.bounds.size.width - 20 - 25
            stepsFrame.origin.y = 31
            stepsFrame.size.width = 25
            stepsFrame.size.height = 16
            guidedTourStepsLabel.frame = stepsFrame
            
            var detailTitleFrame = guidedTourDetailLabel.frame
            detailTitleFrame.origin.x = 20
            detailTitleFrame.origin.y = 49
            detailTitleFrame.size.width = self.bounds.size.width - 60
            detailTitleFrame.size.height = self.detailLabelHeight ?? 50
            guidedTourDetailLabel.frame = detailTitleFrame
            
            var nextButtonFrame = nextActionViewButton.frame
            nextButtonFrame.origin.x = self.bounds.size.width - nextButtonWidth - 20.0
            nextButtonFrame.origin.y = self.bounds.size.height - nextButtonHeight - 16.0
            nextButtonFrame.size.width = nextButtonWidth
            nextButtonFrame.size.height = nextButtonHeight
            nextActionViewButton.frame = nextButtonFrame
        case .down:
            var titleFrame = guidedTourTitleLabel.frame
            titleFrame.origin.x = 20
            titleFrame.origin.y = 16
            titleFrame.size.width = self.bounds.size.width - 60
            titleFrame.size.height = 16
            guidedTourTitleLabel.frame = titleFrame
            
            var stepsFrame = guidedTourStepsLabel.frame
            stepsFrame.origin.x = self.bounds.size.width - 20 - 25
            stepsFrame.origin.y = 16
            stepsFrame.size.width = 25
            stepsFrame.size.height = 16
            guidedTourStepsLabel.frame = stepsFrame
            
            var detailTitleFrame = guidedTourDetailLabel.frame
            detailTitleFrame.origin.x = 20
            detailTitleFrame.origin.y = 34
            detailTitleFrame.size.width = self.bounds.size.width - 60
            detailTitleFrame.size.height = self.detailLabelHeight ?? 50
            guidedTourDetailLabel.frame = detailTitleFrame
            
            var nextButtonFrame = nextActionViewButton.frame
            nextButtonFrame.origin.x = self.bounds.size.width - nextButtonWidth - 20.0
            nextButtonFrame.origin.y = self.bounds.size.height - nextButtonHeight - 31.0
            nextButtonFrame.size.width = nextButtonWidth
            nextButtonFrame.size.height = nextButtonHeight
            nextActionViewButton.frame = nextButtonFrame
        }
    }
    
    private func calculateViewHeight() {
        
    }
}

extension Reactive where Base: GuidedTourDetailView {
    var title: Binder<String?> {
        return self.base.guidedTourTitleLabel.rx.text
    }
    
    var description: Binder<String?> {
        return self.base.guidedTourDetailLabel.rx.text
    }
    
    var nextButtonTitle: Binder<String?> {
        return self.base.nextActionViewButton.rx.title(for: .normal)
    }
    
    var stepLabelText: Binder<String?> {
        return self.base.guidedTourStepsLabel.rx.text
    }
}

