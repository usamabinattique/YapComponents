//
//  StepProgressView.swift
//  YAPKit
//
//  Created by Zain on 17/11/2020.
//  Copyright © 2020 YAP. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class ProgressStep: UIView {
    
    // MARK: - Views
    
    fileprivate lazy var label = UILabelFactory.createUILabel(with: .white, textStyle: .small, alignment: .center)
    
    private lazy var imageView = UIImageViewFactory.createImageView(mode: .center, image: UIImage.sharedImage(named: "icon_check")?.asTemplate, tintColor: .white)
    
    // MARK: - Properties
    
    var progress: Progress = .outstanding {
        didSet {
            self.updateProgress(progress)
        }
    }
    
    // MARK: - Initialization
    
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
        updateProgress(.outstanding)
    }
    
    // MARK: - Drawing
    
    override func draw(_ rect: CGRect) {
        render()
    }
    
    // MARK: - Methods
    
    private func updateProgress(_ progress: Progress) {
        switch progress {
        case .outstanding:
            backgroundColor = .primaryDark
            imageView.isHidden = true
            label.isHidden = false
        case .ongoing:
            backgroundColor = .primary
            imageView.isHidden = true
            label.isHidden = false
        case .completed:
            backgroundColor = .primary
            imageView.isHidden = false
            label.isHidden = true
        }
    }
}

// MARK: - View setup

private extension ProgressStep {
    func setupViews() {
        addSubview(label)
        addSubview(imageView)
        label.adjustsFontSizeToFitWidth = true
    }
    
    func setupConstraints() {
        label.alignAllEdgesWithSuperview()
        imageView.alignAllEdgesWithSuperview()
        
        height(constant: 32)
        width(constant: 32)
    }
    
    func render() {
        roundView()
    }
}

// MARK: - Progress line

class ProgressLine: UIView {
    
    // MARK: - Initialization
    
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
}

// MARK: - View setup

private extension ProgressLine {
    func setupViews() {
        backgroundColor = UIColor.primaryDark.withAlphaComponent(0.32)
    }
    
    func setupConstraints() {
        height(constant: 1)
        width(constant: 25)
    }
}

// MARK: - Progress

extension ProgressStep {
    enum Progress {
        case outstanding
        case ongoing
        case completed
    }
}

public class StepProgressView: UIControl {
    
    
    // MARK: - Views
    
    private lazy var stack = UIStackViewFactory.createStackView(with: .horizontal, alignment: .center, distribution: .fill, spacing: 8)
    
    // MARK: - Initialization
    
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
    
    // MARK: - Properties
    
    public var steps: UInt = 1 {
        didSet {
            updateSteps(steps)
        }
    }
    
    public var progress: Int = -1 {
        didSet {
            updateProgress(progress)
            if progress != oldValue {
                sendActions(for: .valueChanged)
            }
        }
    }
    
    private var progressSteps = [ProgressStep]()
    private var progressLines = [ProgressLine]()
}

// MARK: - View setup

private extension StepProgressView {
    
    func setupViews() {
        addSubview(stack)
    }
    
    func setupConstraints() {
        stack.alignAllEdgesWithSuperview()
    }
}

// MARK: - Progress calculations


private extension StepProgressView {
    func updateSteps(_ steps: UInt) {
        progressSteps.forEach{
            stack.removeArrangedSubview($0)
            $0.removeFromSuperview() }
        progressLines.forEach{
            stack.removeArrangedSubview($0)
            $0.removeFromSuperview() }
        
        progressSteps.removeAll()
        progressLines.removeAll()
        
        (0..<steps).forEach { step in
            if step > 0 {
                let progressLine = ProgressLine()
                progressLine.translatesAutoresizingMaskIntoConstraints = false
                progressLines.append(progressLine)
                stack.addArrangedSubview(progressLine)
            }
            
            let progressStep = ProgressStep()
            progressStep.translatesAutoresizingMaskIntoConstraints = false
            progressStep.label.text = "\(step+1)"
            progressSteps.append(progressStep)
            stack.addArrangedSubview(progressStep)
        }
        
        updateProgress(progress)
    }
    
    func updateProgress(_ progress: Int) {
        progressSteps.enumerated().forEach{ index, progressView in
            progressView.progress = progress < index ? .outstanding : progress == index ? .ongoing : .completed
        }
    }
}

// MARK: - Reactive

public extension Reactive where Base: StepProgressView {
    var progress: ControlProperty<Int> {
        return base.rx.controlProperty(editingEvents: .valueChanged, getter: { progressView in
            return progressView.progress
        }) { (progressView, progress) in
            progressView.progress = progress
        }
    }
    
    var steps: Binder<UInt> {
        return Binder(self.base) { progressView, steps -> Void in
            progressView.steps = steps
        }
    }
}
