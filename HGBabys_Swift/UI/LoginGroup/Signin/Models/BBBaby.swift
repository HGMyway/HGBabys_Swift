//
//  HGBaby.swift
//  HGBabys_Swift
//
//  Created by 小雨很美 on 2017/8/30.
//  Copyright © 2017年 小雨很美. All rights reserved.
//

import Foundation

class BBBaby: Codable {
	var id: Int?
	var babyname: String?
	var state: Int?

	var nickname: String?
	var gender: String?
	var age: Int?
	var birthday: String?
	var lastdevice: String?
	var lastversion: String?
	var lastlogintime: String?
	var registerDate: String?
	var phone: String?
	var email: String?
	var city: String?
	var wxno: String?

	class func hg_decode(data: Any?) -> BBBaby?{
		if let data = data as? [String: Any] {
			if let json = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted){
				let decoder = JSONDecoder()
				let baby  = try? decoder.decode(BBBaby.self, from: json)
 				return baby
			}
		}
		return nil
	}
}


