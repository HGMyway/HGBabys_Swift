//
//  BBSignupViewController.swift
//  HGBabys_Swift
//
//  Created by 小雨很美 on 2017/8/30.
//  Copyright © 2017年 小雨很美. All rights reserved.
//

import UIKit

class BBSignupViewController: UIViewController {

	var bbsignup = BBSignup()


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

		
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

// MARK: - IBActions

	@IBAction func babynameTextChangeAction(_ sender: UITextField) {
		bbsignup.babyname = sender.text
	}

	@IBAction func passwordTextChangeAction(_ sender: UITextField) {
		bbsignup.password = sender.text
	}

	@IBAction func sginupButtonAction(_ sender: UIButton) {
		if let msg = bbsignup.checkSignupData() {
			toast(msg)
		}else{
			requestForSignUp()
		}

	}
	
	@IBAction func backAction(_ sender: UIBarButtonItem) {
		dismiss(animated: true, completion: nil)
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



// MARK: - 网路请求
extension BBSignupViewController{
	func requestForSignUp()  {
		HGNetWork.default.request(HTTPType.baseUrl(APIManager.api_baby_registerBaby), method: .post, parameters: bbsignup.toParams) { (respose, data, hgerror) in

			if hgerror != nil{
				self.toast(hgerror?.message)
			}else{
				self.toast("注册成功")
			}

		}
	}
}
