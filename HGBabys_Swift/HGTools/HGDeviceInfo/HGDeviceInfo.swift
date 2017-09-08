//
//  HGDeviceInfo.swift
//  HGBabys_Swift
//
//  Created by 小雨很美 on 2017/9/3.
//  Copyright © 2017年 小雨很美. All rights reserved.
//

import Foundation
struct HGDeviceInfo {

	/// 手机ID
	static var phoneID: String {return UIDevice.current.identifierForVendor?.description ?? "phoneID" }
	/// 手机型号
	static var phoneModel: String {return UIDevice.current.model }
	/// 手机系统名称
	static var systemName: String{ return UIDevice.current.systemName }
	/// 手机系统版本
	static var systemVersion: String{ return UIDevice.current.systemVersion }
	/// 手机别名： 用户定义的名称
	static var userPhoneName: String{ return UIDevice.current.name }


	/// appid
	static var appIdentifier: String{ return Bundle.main.infoDictionary?[kCFBundleIdentifierKey! as String] as? String ?? "Unknown" }

	/// 应用版本
	static var appVersion: String{ return Bundle.main.infoDictionary?[kCFBundleVersionKey! as String] as? String ?? "Unknown" }

	static var deviceInfo: [String: String] {
		return  ["phoneModel": HGDeviceInfo.phoneModel
			,"deviceId": HGDeviceInfo.phoneID
			,"systemName": HGDeviceInfo.systemName
			,"systemVersion": HGDeviceInfo.systemVersion
			,"userPhoneName": HGDeviceInfo.userPhoneName
			,"appIdentifier": HGDeviceInfo.appIdentifier
			,"appVersion": HGDeviceInfo.appVersion
			]
	}

}
