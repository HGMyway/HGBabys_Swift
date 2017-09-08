//
//  BBOpenGLViewController.swift
//  HGBabys_Swift
//
//  Created by 小雨很美 on 2017/9/4.
//  Copyright © 2017年 小雨很美. All rights reserved.
//

import UIKit
import GLKit
//import OpenGLES.ES3
class BBOpenGLViewController: UIViewController {

	lazy fileprivate(set) var glkView: GLKView = {
		let glkV = GLKView()
		self.view.addSubview(glkV)
		glkV.snp.makeConstraints { (make) in
			make.edges.equalToSuperview()
		}
		glkV.delegate = self
		return glkV
	}()
	lazy fileprivate var displayLink: CADisplayLink = {
		let disp = CADisplayLink(target: self, selector: #selector(BBOpenGLViewController.drawView))
		disp.preferredFramesPerSecond = self.preferredFramesPerSecond //max(1, 60 / self.preferredFramesPerSecond)
		disp.add(to: RunLoop.current, forMode: .commonModes)
		return disp
	}()

	
	var preferredFramesPerSecond: Int = 0 {
		didSet{ displayLink.preferredFramesPerSecond = preferredFramesPerSecond }

	}
	var isPaused: Bool {
		get{ return displayLink.isPaused }
		set{  displayLink.isPaused = newValue }
	}


    override func viewDidLoad() {
        super.viewDidLoad()

		preferredFramesPerSecond = 50
		view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

    }

	@objc func drawView()  {
		updata()
		glkView.display()
	}
	func updata ()  {

	}



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension BBOpenGLViewController: GLKViewDelegate{
	func glkView(_ view: GLKView, drawIn rect: CGRect) {

	}
}

