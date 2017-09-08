//
//  BBSignin.swift
//  HGBabys_Swift
//
//  Created by 小雨很美 on 2017/8/31.
//  Copyright © 2017年 小雨很美. All rights reserved.
//

import Foundation

struct Keys_Baby_Sign {
	static let babyName = "Keys_User_Login_UserName"
	static let password = "Keys_User_Login_PassWord"
	static let signState = "Keys_User_Login_State"
	static let signData = "Keys_User_Login_Data"

}

struct BBSignin {
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

	static var currenLogin: BBSignin = {
		let userDef = UserDefaults.standard
		let babyname = userDef.string(forKey: Keys_Baby_Sign.babyName)
		let password = userDef.string(forKey: Keys_Baby_Sign.password)
		let current = BBSignin(babyname: babyname, password: password)
		return current
	}()

	static var currentBaby: BBBaby? = {
		if let loginArchiveData = UserDefaults.standard.data(forKey: Keys_Baby_Sign.signData) , let loginUnarchiveData = NSKeyedUnarchiver.unarchiveObject(with: loginArchiveData) {
			return BBBaby.hg_decode(data: loginUnarchiveData)
		}
		return BBBaby()
	}()

	func saveSignin()  {
		let userDef = UserDefaults.standard
		userDef.set(babyname, forKey: Keys_Baby_Sign.babyName)
		userDef.set(password, forKey: Keys_Baby_Sign.password)
		userDef.synchronize()
	}


	static var isSignin: Bool  {
		let signState = UserDefaults.standard.bool(forKey: Keys_Baby_Sign.signState)
		return signState
	}

	static func saveSignData(_ signDict: Dictionary<String, Any>?) {
		activeSignData(signDict)
		setPushNotificationAccountWithCurUser()
	}
	private static  func activeSignData(_ signDict : Dictionary<String, Any>?)  {
		currentBaby = BBBaby.hg_decode(data: signDict)
		let userDef = UserDefaults.standard
		userDef.set(true, forKey: Keys_Baby_Sign.signState)
		if signDict != nil{
			let signData = NSKeyedArchiver.archivedData(withRootObject: signDict!)
			userDef.set(signData, forKey: Keys_Baby_Sign.signData)
		}else{
			userDef.removeObject(forKey: Keys_Baby_Sign.signData)
		}
		userDef.synchronize()
	}

	static func sginout(_ deletePassWord: Bool = false){
		let userDef = UserDefaults.standard
		userDef.set(false, forKey: Keys_Baby_Sign.signState)
		if deletePassWord {
			userDef.removeObject(forKey: Keys_Baby_Sign.password)
			currenLogin.password  = nil
		}
		userDef.synchronize()
		setPushNotificationAccountWithCurUser()
	}

	private  static  func setPushNotificationAccountWithCurUser() {

	}
}


