//
//  File.swift
//  YapPakistanApp
//
//  Created by Sarmad on 24/08/2021.
//

import UIKit


public class UIFactory {}

public extension UIFactory {
    class func makeView(with color:UIColor = .clear,
                        alpha:CGFloat = 1,
                        cornerRadious:CGFloat = 0,
                        borderColor:UIColor = .clear,
                        borderWidth:CGFloat = 0 ) -> UIView {
        return View()
            .setAlpha(alpha)
            .setBackgroundColor(color)
            .setCornerRadius(cornerRadious)
            .setBorder(borderColor, width: borderWidth)
    }
}

public extension UIFactory {
    class func makeCircularView(color:UIColor = .clear,
                          alpha:CGFloat = 1,
                          borderColor:UIColor = .clear,
                          borderWidth:CGFloat = 0) -> UIView {
        return CircularView()
            .setAlpha(alpha)
            .setBackgroundColor(color)
            .setBorder(borderColor, width: borderWidth)
    }
}

public extension UIFactory {
    class func makeLabel (
        font:UIFont = UIFont.systemFont(ofSize: 16),
        alignment: NSTextAlignment = .left,
        numberOfLines: Int = 1,
        lineBreakMode: NSLineBreakMode = .byTruncatingTail,
        text: String? = nil,
        charSpace: Float? = nil,
        lineSpace: CGFloat? = nil,
        alpha: CGFloat = 1.0,
        adjustFontSize: Bool = false,
        insects:UIEdgeInsets = .zero
    ) -> Label {
        
        let label = Label()
            .setFont(font: font)
            .setTextAlligned(alignment)
            .setNumberOfLines(numberOfLines)
            .setLineBreakMode(lineBreakMode)
            .setText(text ?? "")
            .setAlpha(alpha)
            .setTranslatesAutoresizingMask(false)
            .setAdjustsFontSizeToFitWidth(adjustFontSize)
            .setInsets(insects)
        
        if let space = charSpace { label.spacing = space }
        if let space = lineSpace { label.lineSpacing = space }
        
        return label
    }
}

public extension UIFactory {
    class func makeImageView(name:String,
                             tintColor:UIColor = .black,
                             contentMode:UIView.ContentMode = .scaleAspectFit,
                             rendringMode:UIImage.RenderingMode = .alwaysOriginal
                             ) -> ImageView {
        return ImageView()
            .setTintColor(tintColor)
            .setContentMode(contentMode)
            .setImage(name, rendringMode: rendringMode)
    }
    
    class func makeImageView(image:UIImage? = nil,
                             tintColor:UIColor = .black,
                             contentMode:UIView.ContentMode = .scaleAspectFit,
                             rendringMode:UIImage.RenderingMode = .alwaysOriginal
                             ) -> ImageView {
        return ImageView()
            .setTintColor(tintColor)
            .setContentMode(contentMode)
            .setImage(image, rendringMode: rendringMode)
            .setBackgroundColor(.clear)
    }
}

public extension UIFactory {
    class func makeTableView (allowsSelection: Bool = true) -> TableView {
        let tableView = TableView()
        tableView.allowsSelection = allowsSelection
        return tableView
    }
}

public extension UIFactory {
    class func makeCollectionView(with color:UIColor,
                                  collectionViewLayout:UICollectionViewLayout
                                  ) -> CollectionView {
        return CollectionView(collectionViewLayout: collectionViewLayout)
            .setBackgroundColor(color)
    }
}

public extension UIFactory {
    class func makeOnBoardingProgressView(
        with backImage:UIImage?,
        completionImage:UIImage?
    ) -> OnBoardingProgressView {
        let progressView = OnBoardingProgressView.init()
        
        progressView.backImage = backImage
        progressView.completionImage = completionImage
        
        return progressView
    }
}


public extension UIFactory {
    class func makeButton(with font:UIFont, backgroundColor:UIColor? = nil, title:String? = nil) -> UIButton  {
        let button = Button()
        if let backgroundColor = backgroundColor { button.backgroundColor = backgroundColor }
        button.titleLabel?.font = font
        button.setTitle(title, for: .normal)
        return button
    }
}

public extension UIFactory {
    class func makePaddingLabel (
        font:UIFont = UIFont.systemFont(ofSize: 16),
        alignment: NSTextAlignment = .left,
        numberOfLines: Int = 1,
        lineBreakMode: NSLineBreakMode = .byTruncatingTail,
        text: String? = nil,
        alpha: CGFloat = 1.0,
        adjustFontSize: Bool = false
    ) -> PaddedLabel {
        
        let label = PaddedLabel()
            .setFont(font: font)
            .setTextAlligned(alignment)
            .setNumberOfLines(numberOfLines)
            .setLineBreakMode(lineBreakMode)
            .setText(text ?? "")
            .setAlpha(alpha)
            .setTranslatesAutoresizingMask(false)
            .setAdjustsFontSizeToFitWidth(adjustFontSize)
        
        return label
    }
}

public class PaddedLabel: UILabel {
    
    public var topInset: CGFloat = 5.0
    public var bottomInset: CGFloat = 5.0
    public var leftInset: CGFloat = 7.0
    public var rightInset: CGFloat = 7.0
    
    var edgeInset: CGFloat = 0 {
        didSet {
            topInset = edgeInset
            bottomInset = edgeInset
            leftInset = edgeInset
            rightInset = edgeInset
        }
    }
    
    public override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
    
    public override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }
    
    public override func sizeToFit() {
        super.sizeThatFits(intrinsicContentSize)
    }
}

public extension UIFactory {
    class func createGifImageView(mode: UIImageView.ContentMode = .scaleAspectFill, image: UIImage? = nil, tintColor: UIColor = .clear) -> GifImageView {
        let imageView = GifImageView()
        imageView.contentMode = mode
        imageView.tintColor = tintColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = image
        return imageView
    }
}

public class GifImageView: UIImageView{
    
}
