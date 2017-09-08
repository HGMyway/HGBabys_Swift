


//
//  BBJianShuViewController.swift
//  HGBabys_Swift
//
//  Created by 小雨很美 on 2017/9/5.
//  Copyright © 2017年 小雨很美. All rights reserved.
//

import UIKit

class BBJianShuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		requestData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension BBJianShuViewController{
	func requestData()  {
		let url = "https://www.jianshu.com/p/c9c021b70927"

		HGNetWork.default.request(HTTPType.fullUrl(url)) {(response, data, hgerror) in
			print(data)
		}


	}
}
