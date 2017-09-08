//
//  HGViewControllerAnimatedTransitioning
//  NGRLearnRN
//
//  Created by 小雨很美 on 2017/8/9.
//  Copyright © 2017年 小雨很美. All rights reserved.
//

import UIKit

enum PresentSide {
	case showFromLeft
	case showFromRight
}
class HGViewControllerAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {

	var presenting = true
	var showHostAnimate = false

	var presentSide = PresentSide.showFromRight
	var duration = 0.5


	func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
		return duration
	}

	func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		let containerView: UIView = transitionContext.containerView
		guard let fromVC  = transitionContext.viewController(forKey: .from) else { return }
		guard let toVC  = transitionContext.viewController(forKey: .to) else { return }

		containerView.addSubview(toVC.view)

		func presentVCStartFrame() -> CGRect{
			var frame = containerView.bounds
			switch presentSide {
			case .showFromLeft:
				frame.hg_maxX = 0
				return frame
			default:
				frame.hg_minX = frame.hg_width
				return frame
			}
		}
		func hostVCEndFrame() -> CGRect{
			var frame = containerView.bounds
			switch presentSide {
			case .showFromLeft:
				frame.hg_minX = frame.hg_width
				return frame
			default:
				frame.hg_maxX = 0
				return frame
			}
		}
		/// 出现
		///
		/// - Parameters:
		///   - fromVC: <#fromVC description#>
		///   - toVC: <#toVC description#>
		func animateShow(fromVC: UIViewController, toVC: UIViewController){
			toVC.view.frame = presentVCStartFrame()
			UIView.animate(withDuration: duration, animations: {
				fromVC.view.tintAdjustmentMode = UIViewTintAdjustmentMode.automatic
				toVC.view.frame = containerView.bounds
				if self.showHostAnimate { fromVC.view.frame = hostVCEndFrame() }

			}, completion: { (finish) in
				transitionContext.completeTransition(true)
			})
		}


		func animateDismiss(fromVC: UIViewController, toVC: UIViewController){
			containerView.bringSubview(toFront: fromVC.view)
			UIView.animate(withDuration: duration, animations: {
				toVC.view.tintAdjustmentMode = UIViewTintAdjustmentMode.automatic
				fromVC.view.frame = presentVCStartFrame()
				toVC.view.frame = containerView.frame
			}, completion: { (finish) in
				fromVC.view.removeFromSuperview()
				transitionContext.completeTransition(true)
			})
		}


		if(presenting) {
			animateShow(fromVC: fromVC, toVC: toVC)
		} else {
			animateDismiss(fromVC: fromVC, toVC: toVC)
		}
	}
}


