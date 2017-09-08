//
//  HGKit.swift
//  BabysCard_Swift
//
//  Created by 小雨很美 on 2017/6/28.
//  Copyright © 2017年 小雨很美. All rights reserved.
//

import Foundation
import UIKit
extension UIImage{

	class  func imageCorner (color: UIColor , rect: CGRect , alpha: CGFloat = 1.0) -> UIImage {
		let img = image(color: color, rect: rect, alpha: alpha)
		let fram = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
		UIGraphicsBeginImageContextWithOptions(img.size, false, 1.0)
		UIBezierPath(roundedRect: fram, cornerRadius: rect.size.width/2.0).addClip()
		img.draw(in: fram)
		let imagee = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return imagee!
	}

	class  func image (color: UIColor , rect: CGRect =  CGRect(x: 0, y: 0, width: 1, height: 1) , alpha: CGFloat = 1.0) -> UIImage {
		UIGraphicsBeginImageContext(rect.size)
		let context = UIGraphicsGetCurrentContext()
		context?.setFillColor(color.cgColor)
		context?.setAlpha(alpha)
		context?.fill(rect)
		let img = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return img!
	}
}


extension UINavigationController
{
	func resetNavigationbar()  {
		self.navigationBar.setBackgroundImage(nil, for: .default)
		self.navigationBar.shadowImage = nil;
		//
	}
	func setNavigationbarClear()  {
		setNavigationColor(color: #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0))
	}
	func setNavigationColor(color: UIColor, alpha: CGFloat = 1.0)  {
		self.navigationBar.shadowImage = UIImage()
		self.navigationBar.setBackgroundImage(UIImage.image(color:color), for: .default)
	}
}


extension CGRect{
	var hg_height: CGFloat{
		get{ return height }
		set{ self = CGRect(x: minX, y: minY, width: width, height: newValue) }
	}
	var hg_width: CGFloat{
		get{ return width }
		set{ self = CGRect(x: minX, y: minY, width: newValue, height: height) }
	}
	var hg_minX: CGFloat{
		get{ return minX }
		set{ self = CGRect(x: newValue, y: minY, width: width, height: height) }
	}
	var hg_minY: CGFloat{
		get{ return minY }
		set{ self = CGRect(x: minX, y: newValue, width: width, height: height) }
	}
	var hg_maxX: CGFloat{
		get{ return maxX }
		set{ self = CGRect(x: newValue - width, y: minY, width: width, height: height) }
	}
	var hg_maxY: CGFloat{
		get{ return maxY }
		set{ self = CGRect(x: minX, y: newValue - height, width: width, height: height) }
	}
	var hg_midX: CGFloat{
		get{ return midX }
		set{ self = CGRect(x: newValue - width / 2, y: minY, width: width, height: height) }
	}
	var hg_midY: CGFloat{
		get{ return midY }
		set{ self = CGRect(x: minX, y: newValue - height / 2, width: width, height: height) }
	}

}
extension UIView{
	var height: CGFloat {
		get{ return self.frame.hg_height }
		set{ self.frame.hg_height = newValue }
	}
	var width: CGFloat {
		get{ return self.frame.hg_width }
		set{ self.frame.hg_width = newValue }
	}
	var top: CGFloat {
		get{ return self.frame.hg_minY }
		set{ self.frame.hg_minY = newValue }
	}
	var left: CGFloat {
		get{ return self.frame.hg_minX }
		set{ self.frame.hg_minX = newValue }
	}
	var bottom: CGFloat {
		get{ return self.frame.hg_maxY }
		set{ self.frame.hg_maxY = newValue }
	}
	var right: CGFloat {
		get{ return self.frame.hg_maxX }
		set{ self.frame.hg_maxX = newValue }
	}
}








