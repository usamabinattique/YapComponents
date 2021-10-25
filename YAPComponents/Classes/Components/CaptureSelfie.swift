//
//  CaptureSelfie.swift
//  Pods
//
//  Created by Sarmad on 20/10/2021.
//

import AVFoundation
import CoreImage
import UIKit

public class CaptureSelfie: UIView {
    // MARK: - Private Properties

    private lazy var device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)

    private lazy var captureSession = AVCaptureSession()

    private lazy var previewLayer: AVCaptureVideoPreviewLayer = {
        let preview = AVCaptureVideoPreviewLayer(session: self.captureSession)
        preview.videoGravity = .resizeAspect
        return preview
    }()

    private let videoOutput = AVCaptureVideoDataOutput()
    private var frameImage: CVImageBuffer?

    private lazy var viewGuide: PartialTransparentView! = {
        let width = UIScreen.main.bounds.width - (UIScreen.main.bounds.width * 0.4)
        let height = width + (width * 0.2)
        let viewX = (UIScreen.main.bounds.width / 2) - (width / 2)
        let viewY = (UIScreen.main.bounds.height / 2) - (height / 2) - (height / 7)

        let viewg = PartialTransparentView(rectsArray: [CGRect(x: viewX, y: viewY, width: width, height: height)])
        viewg.translatesAutoresizingMaskIntoConstraints = false
        return viewg
    }()

    // MARK: - Public Properties
    public var themeColor: UIColor! = .blue { didSet {
        viewGuide.lineColor = themeColor
        buttonComplete?.backgroundColor = themeColor
    } }

    public lazy var labelHintTop: UILabel? = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.text = "Align your face in the center of the circule and press the button"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()

    public lazy var buttonComplete: CaptureButton? = {
        let button = CaptureButton()
        button.backgroundColor = themeColor
        button.addTarget(self, action: #selector(scanCompleted), for: .touchUpInside)
        return button
    }()

    // MARK: - Instance dependencies
    typealias ResultsHandlerType = (_ number: UIImage?) -> Void?

    private var resultsHandler: ResultsHandlerType

    // MARK: - Initializers

    init(resultsHandler: @escaping ResultsHandlerType) {
        self.resultsHandler = resultsHandler
        super.init(frame: .zero)
        viewDidLoad()
    }

    public class func getScanner(resultsHandler: @escaping (_ number: UIImage?) -> Void?) -> UIView {
        let viewScanner = CaptureSelfie(resultsHandler: resultsHandler)
        return viewScanner
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        stop()
    }

    public func startSession() {
        captureSession.startRunning()
    }

    private func viewDidLoad() {
        setupCaptureSession()
        startSession()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        previewLayer.frame = bounds
    }

    // MARK: - Add Views

    private func setupCaptureSession() {
        addCameraInput()
        addPreviewLayer()
        addVideoOutput()
        addGuideView()
    }

    private func addCameraInput() {
        guard let device = device else { return }
        let cameraInput = try! AVCaptureDeviceInput(device: device)
        captureSession.addInput(cameraInput)
    }

    private func addPreviewLayer() {
        layer.addSublayer(previewLayer)
    }

    private func addVideoOutput() {
        videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as NSString: NSNumber(value: kCVPixelFormatType_32BGRA)] as [String: Any]
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "my.image.handling.queue"))
        captureSession.addOutput(videoOutput)
        guard let connection = videoOutput.connection(with: AVMediaType.video),
              connection.isVideoOrientationSupported else {
            return
        }
        connection.videoOrientation = .portrait
    }

    private func addGuideView() {

        backgroundColor = .black
        addSubview(viewGuide)
        bringSubviewToFront(viewGuide)
        addSubview(labelHintTop!)
        addSubview(buttonComplete!)

        viewGuide.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        viewGuide.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        viewGuide.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        viewGuide.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true

        labelHintTop?.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        labelHintTop?.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true

        let width = UIScreen.main.bounds.width - (UIScreen.main.bounds.width * 0.4)
        let viewY = (UIScreen.main.bounds.height / 2) - (width * ( 1.2 / 2 - 1.2 / 7))

        labelHintTop?.centerYAnchor.constraint(equalTo: topAnchor, constant: viewY / 2).isActive = true


        buttonComplete?.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -50).isActive = true
        buttonComplete?.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        buttonComplete?.heightAnchor.constraint(equalToConstant: 80).isActive = true
        buttonComplete?.widthAnchor.constraint(equalToConstant: 80).isActive = true
    }

    // MARK: - Completed process

    @objc func scanCompleted() {
        guard let frame = frameImage else { return }
        let image = UIImage(ciImage: CIImage(cvImageBuffer: frame))
        resultsHandler(image)
        stop()
    }

    private func stop() {
        captureSession.stopRunning()
    }

    // MARK: - Payment detection

    private func handleObservedPaymentCard(in frame: CVImageBuffer) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.extractData(frame: frame)
        }
    }

    private func extractData(frame: CVImageBuffer) {

    }

    private func tapticFeedback() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }
}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate

extension CaptureSelfie: AVCaptureVideoDataOutputSampleBufferDelegate {
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let frame = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            debugPrint("unable to get image from sample buffer")
            return
        }

        self.frameImage = frame

        // let ciImage = CIImage(cvImageBuffer: frame)
        // handleObservedPaymentCard(in: frame)
    }
}

// MARK: - Class PartialTransparentView

class PartialTransparentView: UIView {
    var rectsArray: [CGRect]?

    var lineColor: UIColor? {
        set { self.shapeLayer.strokeColor = newValue?.cgColor }
        get { UIColor(cgColor: self.shapeLayer.strokeColor ?? UIColor.clear.cgColor ) }
    }

    private let shapeLayer = CAShapeLayer()

    convenience init(rectsArray: [CGRect]) {
        self.init()

        self.rectsArray = rectsArray

        backgroundColor = UIColor.black.withAlphaComponent(0.25)
        isOpaque = false
    }

    override func draw(_ rect: CGRect) {
        backgroundColor?.setFill()
        UIRectFill(rect)

        guard let rectsArray = rectsArray else {
            return
        }

        for holeRect in rectsArray {
            let path = UIBezierPath(ovalIn: holeRect)

            let holeRectIntersection = rect.intersection(holeRect)
            UIRectFill(holeRectIntersection)
            UIColor.clear.setFill()
            UIGraphicsGetCurrentContext()?.setBlendMode(CGBlendMode.copy)
            path.fill()

            shapeLayer.path = path.cgPath
            shapeLayer.fillColor = UIColor.clear.cgColor
            shapeLayer.lineWidth = 2

            self.layer.addSublayer(shapeLayer)
        }
    }
}


public class CaptureButton: UIButton {

    public override var backgroundColor: UIColor? {
        set {
            super.backgroundColor = newValue
            borderViewButton.backgroundColor = newValue
        }
        get {
            super.backgroundColor
        }
    }

    public lazy var borderViewButton: UIView = {
        let bview = UIView()
        bview.translatesAutoresizingMaskIntoConstraints = false
        bview.layer.borderWidth = 2
        bview.layer.borderColor = UIColor.white.cgColor
        bview.isUserInteractionEnabled = false
        return bview
    }()

    public convenience init() { self.init(frame: .zero) }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        uiSetup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        uiSetup()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        layoutSetup()
    }

    private func uiSetup() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.masksToBounds = true
        backgroundColor = .blue

        addSubview(borderViewButton)

        NSLayoutConstraint.activate([
            borderViewButton.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            borderViewButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            borderViewButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            borderViewButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -10)
        ])
    }

    private func layoutSetup() {
        layer.cornerRadius = frame.size.height / 2
        borderViewButton.layer.cornerRadius = borderViewButton.frame.size.height / 2
    }
}
