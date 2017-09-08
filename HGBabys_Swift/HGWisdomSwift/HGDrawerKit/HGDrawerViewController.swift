//
//  HGDrawerViewController.swift
//  NGRLearnRN
//
//  Created by 小雨很美 on 2017/8/9.
//  Copyright © 2017年 小雨很美. All rights reserved.
//

import UIKit



class HGDrawerViewController: UIViewController {

	@IBOutlet weak var alphaView: UIView!
	@IBOutlet weak var contentView: UIView!


	let customAn = { () -> HGViewControllerAnimatedTransitioning in
		let cusoman = HGViewControllerAnimatedTransitioning()
		cusoman.showHostAnimate = true
		return cusoman
	}()

	let animateTime = 0.3


	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		modalPresentationStyle = .overFullScreen
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		modalPresentationStyle = .overFullScreen
		//		fatalError("init(coder:) has not been implemented")
	}


	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .clear
		addAlphaTap()
	}


	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		showAnimate()
	}
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
	}

	// MARK: - Action

	fileprivate func addAlphaTap()  {
		let tap = UITapGestureRecognizer(target: self, action: #selector(HGDrawerViewController.viewTapAction(_:)))

		alphaView.addGestureRecognizer(tap)
	}

	@objc fileprivate  func viewTapAction(_ sender: UITapGestureRecognizer) {
		hiddenAnimate { (completion) in
			self.dismiss(animated: false) {
			}
		}
	}


	// MARK: - Navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		segue.destination.transitioningDelegate = self
//		hiddenAnimate()
	}
}



// MARK: - 弹出/收回 动画
extension HGDrawerViewController{
	// MARK: - animall
	fileprivate func showAnimate()  {
		contentView.right = 0
		alphaView.alpha = 0

		UIView.animate(withDuration: animateTime) {
			self.contentView.left = 0
			self.alphaView.alpha = 0.5
		}
	}
	fileprivate func hiddenAnimate(completion: ((Bool) -> Swift.Void)? = nil) {
		UIView.animate(withDuration: animateTime, animations: {
			self.contentView.right = 0
			self.alphaView.alpha = 0
		}, completion: completion)
	}
}

// MARK: - 自定义过场动画
extension HGDrawerViewController: UIViewControllerTransitioningDelegate{
	func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		customAn.presenting = true
		return customAn

	}
	func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		customAn.presenting = false
		return customAn
	}
}






