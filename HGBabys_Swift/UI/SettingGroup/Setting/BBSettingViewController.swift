//
//  BBSettingViewController.swift
//  HGBabys_Swift
//
//  Created by 小雨很美 on 2017/9/2.
//  Copyright © 2017年 小雨很美. All rights reserved.
//

import UIKit

class BBSettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

	@IBAction func dismissAction(_ sender: UIBarButtonItem) {
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
