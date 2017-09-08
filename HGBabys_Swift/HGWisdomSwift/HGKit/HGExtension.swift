//
//  HGExtension.swift
//  NGRLearnRN
//
//  Created by 小雨很美 on 2017/7/30.
//  Copyright © 2017年 小雨很美. All rights reserved.
//

import Foundation
import UIKit
import Toaster
extension UIViewController{
	class func currentVC() -> UIViewController? {
		guard  var window = UIApplication.shared.keyWindow else { return nil}

		func getNormal(_ window: UIWindow) -> UIWindow{
			var rWindow = window
			if rWindow.windowLevel != UIWindowLevelNormal {
				let windows = UIApplication.shared.windows
				for (_, tempWin) in windows.enumerated(){
					if tempWin.windowLevel == UIWindowLevelNormal{
						rWindow = tempWin
						break
					}
				}
			}
			return rWindow
		}

		func getVC(_ window: UIWindow) -> UIViewController?{
			let frontView = window.subviews.first
			let nextResponder = frontView!.next!
			 if let resultVC = nextResponder as? UINavigationController {
				return	 resultVC.visibleViewController
			}else if let resultVC = nextResponder as? UITabBarController {
				if let resultNavVC = resultVC.selectedViewController as? UINavigationController{
					return resultNavVC.visibleViewController
				}else{
					return	 resultVC.selectedViewController
				}

			}else if let resultVC = nextResponder as? UIViewController {
				return resultVC
			}
			
			return window.rootViewController
		}
		window = getNormal(window)
		let vc = getVC(window)
		return vc
	}


	func toast(_ message: String? = nil)  {
		Toast(text: message).show()
	}
}


extension UIViewController{
	func addEndEditingTap()  {
		let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.endEditingTap(_:)))
		view.addGestureRecognizer(tap)
	}
	@objc fileprivate func endEditingTap(_ tap: UITapGestureRecognizer)  {
		view.endEditing(true)
	}
}

extension Dictionary{
	public mutating func append<S>(contentsOf newElements: S?) where S : Sequence, Element == S.Element{
		if let newElements = newElements {
			for (key, value) in newElements {
				self[key] = value
			}
		}
	}
	var jsonString: String?{
		get{

			if let jsonData = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted){
				return String(data: jsonData, encoding: .utf8)
			}else{
				return nil
			}
		}
	}
}
extension String{
	var jsonAny: Any? {
		get{
			if let jsonData = self.data(using: .utf8){
				if let jsonA = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableLeaves){
					return jsonA
				}
			}
			return nil
		}
	}
	func urlString(_ baseUrl: String?) -> String? {
		guard (baseUrl != nil) else {
			return nil
		}
		return (URL(string: self, relativeTo: URL(string: baseUrl!))?.absoluteString)!
	}
}
