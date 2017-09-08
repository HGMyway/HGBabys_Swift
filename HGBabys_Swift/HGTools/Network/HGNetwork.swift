//
//  HGNetwork.swift
//  BabysCard_Swift
//
//  Created by 小雨很美 on 2017/6/28.
//  Copyright © 2017年 小雨很美. All rights reserved.
//

import Foundation
import UIKit

import Alamofire

enum HTTPType<Value> {
	case fullUrl(String)
	case baseUrl(String)

	public var value: String? {
		switch self {
		case .fullUrl(let string):
			return string
		case .baseUrl(let string):
			return string.urlString(HostManager.host_base)
		}
	}
}
// 网络请求超时时间
//let NetworkTimeoutInterval:Double = 40
class HGNetWork: NSObject {
	open static let `default`: HGNetWork = { return HGNetWork() }()
	//@escaping标明这个闭包是会“逃逸”,通俗点说就是这个闭包在函数执行完成之后才被调用。为了体现@escaping的作用，我们在之前先做一个铺垫：
	public typealias CompletionHandler = (_ response: Alamofire.DataResponse<Any>? ,_ data: Any? ,  _ error: HGError?) -> Void

	open func request(
		_ urlStr: HTTPType<String>,
		method: HTTPMethod = .get,
		parameters: Parameters? = nil,
		headers: HTTPHeaders? = nil,
		completionHandler: @escaping CompletionHandler
		) {

		func resetParam() -> Parameters?{
			if parameters != nil && (method == .get || method == .delete){
					return ["param":parameters!.jsonString ?? ""]
			}
			return parameters
		}

		guard let url = urlStr.value else { return }

		Alamofire.request(url, method: method, parameters: resetParam(), headers: headers).responseJSON
			{ (response) in
				switch response.result{
				case .success(let data ):
					let hgError = HGError.anaysisData(data)
					completionHandler(response,data , hgError)
				case .failure(let error):
					let hgError = HGError(error: error)
					completionHandler(response, nil,hgError)
				}
		}
	}
}




