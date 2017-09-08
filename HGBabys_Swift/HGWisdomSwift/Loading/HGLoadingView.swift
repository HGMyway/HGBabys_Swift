//
//  HGLoadingView.swift
//  BabysCard_Swift
//
//  Created by 小雨很美 on 2017/6/28.
//  Copyright © 2017年 小雨很美. All rights reserved.
//
import UIKit

open class HGLoadingView: UIView {

    // MARK: Properties

    open var text: String? {
        get { return self.textLabel.text }
        set { self.textLabel.text = newValue }
    }
    open var image: UIImage? {
        get { return self.imageView.image }
        set { self.imageView.image = newValue }
    }



    // MARK: Appearance

    /// The background view's color.
    override open dynamic var backgroundColor: UIColor? {
        get { return self.backgroundView.backgroundColor }
        set { self.backgroundView.backgroundColor = newValue }
            }

    /// The background view's corner radius.
//    @objc open dynamic var cornerRadius: CGFloat {
//        get { return self.backgroundView.layer.cornerRadius }
//        set { self.backgroundView.layer.cornerRadius = newValue }
//    }

     @objc open dynamic var contentInsets = UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10)

    /// The inset of the text label.
    @objc open dynamic var textInsets = UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10)

    /// The color of the text label's text.
    @objc open dynamic var textColor: UIColor? {
        get { return self.textLabel.textColor }
        set { self.textLabel.textColor = newValue }
    }

    /// The font of the text label.
    @objc open dynamic var font: UIFont? {
        get { return self.textLabel.font }
        set { self.textLabel.font = newValue }
    }

    /// The bottom offset from the screen's bottom in portrait mode.
    @objc open dynamic var bottomOffsetPortrait: CGFloat = {
        switch UIDevice.current.userInterfaceIdiom {
        case .unspecified: return 30
        case .phone: return 30
        case .pad: return 60
        case .tv: return 90
        case .carPlay: return 30
        }
    }()

    /// The bottom offset from the screen's bottom in landscape mode.
    @objc open dynamic var bottomOffsetLandscape: CGFloat = {
        switch UIDevice.current.userInterfaceIdiom {
        case .unspecified: return 20
        case .phone: return 20
        case .pad: return 40
        case .tv: return 60
        case .carPlay: return 20
        }
    }()


    // MARK: UI

    private let backgroundView: UIView = {
        let `self` = UIView()
        self.backgroundColor = UIColor(white: 0, alpha: 0.7)
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        return self
    }()

    private let imageView: UIImageView = {
        let `self` = UIImageView()

        return self
    }()


    private let textLabel: UILabel = {
        let `self` = UILabel()
        self.textColor = .white
        self.backgroundColor = .clear
        self.font = {
            switch UIDevice.current.userInterfaceIdiom {
            case .unspecified: return .systemFont(ofSize: 12)
            case .phone: return .systemFont(ofSize: 12)
            case .pad: return .systemFont(ofSize: 16)
            case .tv: return .systemFont(ofSize: 20)
            case .carPlay: return .systemFont(ofSize: 12)
            }
        }()
        self.numberOfLines = 0
        self.textAlignment = .center
        return self
    }()



    // MARK: Initializing

    public init() {
        super.init(frame: .zero)
        self.isUserInteractionEnabled = false
        self.addSubview(self.backgroundView)
        self.addSubview(self.textLabel)
        self.addSubview(self.imageView)
    }

    required convenience public init?(coder aDecoder: NSCoder) {
        self.init()
    }


    // MARK: Layout

    override open func layoutSubviews() {
        super.layoutSubviews()
        let containerSize = HGLoadingWindow.shared.frame.size


        let constraintSize = CGSize(
            width: containerSize.width * (280.0 / 320.0),
            height: CGFloat.greatestFiniteMagnitude
        )
        let textLabelSize = self.textLabel.sizeThatFits(constraintSize)
        var imageSize = self.image?.size ?? .zero
        if imageSize.width == 1.0{
            imageSize = CGSize(width: 30, height: 30)
        }

        let contentSize = CGSize(width: max(textLabelSize.width, imageSize.width) + self.contentInsets.left + self.contentInsets.right , height: textLabelSize.height + imageSize.height + self.contentInsets.top + contentInsets.bottom + self.textInsets.top)


        self.imageView.frame = CGRect(
            x: (contentSize.width - imageSize.width) * 0.5,
            y: self.contentInsets.top,
            width: imageSize.width,
            height: imageSize.height
        )
        self.imageView.layer.add(rotationAnimation(), forKey: "rotationAnimation")

        self.textLabel.frame = CGRect(
            x:  (contentSize.width - textLabelSize.width) * 0.5,
            y: self.textInsets.top + self.imageView.frame.maxY,
            width: textLabelSize.width,
            height: textLabelSize.height
        )

        self.backgroundView.frame = CGRect(
            x: 0,
            y: 0,
            width: contentSize.width,
            height: contentSize.height
        )

        var x: CGFloat
        var y: CGFloat
        var width: CGFloat
        var height: CGFloat

        let orientation = UIApplication.shared.statusBarOrientation
        if orientation.isPortrait || !HGLoadingWindow.shared.shouldRotateManually {
            width = containerSize.width
            height = containerSize.height
            y = self.bottomOffsetPortrait
        } else {
            width = containerSize.height
            height = containerSize.width
            y = self.bottomOffsetLandscape
        }

        let backgroundViewSize = self.backgroundView.frame.size
        x = (width - backgroundViewSize.width) * 0.5
//        y = height - (backgroundViewSize.height + y)
        y = (height - backgroundViewSize.height ) * 0.5

        self.isUserInteractionEnabled = false
        self.frame = CGRect(
            x: x,
            y: y,
            width: backgroundViewSize.width,
            height: backgroundViewSize.height
        )
    }

    private func rotationAnimation() -> CABasicAnimation{
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = .pi * 2.0
        rotationAnimation.duration = 0.5
        rotationAnimation.isCumulative = true
        rotationAnimation.repeatCount = 10000
        return rotationAnimation
    }

    override open func hitTest(_ point: CGPoint, with event: UIEvent!) -> UIView? {
        if let superview = self.superview {
            let pointInWindow = self.convert(point, to: superview)
            let contains = self.frame.contains(pointInWindow)
            if contains && self.isUserInteractionEnabled {
                return self
            }
        }
        return nil
    }

}

