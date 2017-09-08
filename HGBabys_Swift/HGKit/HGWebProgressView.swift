//
//  HGWebProgressView.swift
//  HGBabys_Swift
//
//  Created by 小雨很美 on 2017/9/3.
//  Copyright © 2017年 小雨很美. All rights reserved.
//

import UIKit

class HGWebProgressView: UIView {

	var progress: Double = 0{
		willSet{
			guard newValue > progress else { return }
			UIView.animate(withDuration: 0.1) {
				self.progressLayer.frame.hg_width = self.width * CGFloat(self.progress)
			}
		}
		didSet{
			self.isHidden = (progress == 1 || progress == 0)
		}
	}
	var progressColor: UIColor? {
		didSet{
			progressLayer.backgroundColor = progressColor?.cgColor
		}
	}

	fileprivate lazy var progressLayer: CALayer = {
		var layer = CALayer()
		layer.frame.hg_height = self.height
		layer.backgroundColor = self.progressColor?.cgColor ?? #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
		self.layer.addSublayer(layer)
		return layer
	}()


    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
