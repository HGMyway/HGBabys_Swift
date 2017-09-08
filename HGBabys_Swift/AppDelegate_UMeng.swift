//
//  AppDelegate_UMeng.swift
//  HGBabys_Swift
//
//  Created by 小雨很美 on 2017/8/30.
//  Copyright © 2017年 小雨很美. All rights reserved.
//

import Foundation


//struct MobClickEventName {
//	static let signOut = "signOut"
//	static let signIn = "signIn"
//}
//struct MobClickLogPageViewName {
//	static let bookingHome = "bookingHome"
//	static let analy = "bookingHome"
//}
extension AppDelegate{
	func setUMeng()  {


//		MobClick.setLogEnabled(true) //使用集成测试模式请先在程序入口处调用如下代码，打开调试模式
		UMAnalyticsConfig.sharedInstance().appKey = "5948b44076661324b3001e7f"
		MobClick.start(withConfigure: UMAnalyticsConfig.sharedInstance()) //配置以上参数后调用此方法初始化SDK！

	}
}
