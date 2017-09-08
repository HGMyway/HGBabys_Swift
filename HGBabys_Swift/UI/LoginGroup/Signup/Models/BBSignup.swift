//
//  HGSignup.swift
//  HGBabys_Swift
//
//  Created by 小雨很美 on 2017/8/30.
//  Copyright © 2017年 小雨很美. All rights reserved.
//

import Foundation
struct BBSignup {
	var babyname: String?
	var password: String?
	init(babyname: String? = nil, password: String? = nil) {
		self.babyname = babyname
		self.password = password
	}
	var toParams: Dictionary<String, Any>{
		var param : [String: Any] = [:]
		param["babyname"] = babyname
		param["password"] = password
		param.append(contentsOf: HGDeviceInfo.deviceInfo as [String: Any])
		return param
	}

	func checkSignupData() -> String? {
		guard babyname?.isEmpty == false else { return "请输入账号名" }
		guard password?.isEmpty == false else { return "请输入密码" }
		return nil
	}

}
