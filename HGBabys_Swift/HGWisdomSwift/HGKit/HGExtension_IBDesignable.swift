//
//  HGExtension_IBDesignable.swift
//  HGBabys_Swift
//
//  Created by 小雨很美 on 2017/9/2.
//  Copyright © 2017年 小雨很美. All rights reserved.
//

import Foundation

@IBDesignable class IBDesignableView: UIView {
}
@IBDesignable class IBDesignableButton: UIButton {
}
@IBDesignable class IBDesignableImageView: UIImageView {
}
@IBDesignable class IBDesignableLabel: UILabel {
}
extension UIView{
	@IBInspectable var cornerRadius: CGFloat {
		get {
			return layer.cornerRadius
		}
		set {
			layer.cornerRadius = newValue
			layer.masksToBounds = newValue > 0
		}
	}
	@IBInspectable var borderWidth: CGFloat {
		get {
			return layer.borderWidth
		}
		set {
			layer.borderWidth = newValue
		}
	}
	@IBInspectable var borderColor: UIColor? {
		get {
			guard (layer.borderColor != nil) else { return nil }
			return UIColor(cgColor: layer.borderColor!)
		}
		set {
			layer.borderColor = newValue?.cgColor
		}
	}
}
