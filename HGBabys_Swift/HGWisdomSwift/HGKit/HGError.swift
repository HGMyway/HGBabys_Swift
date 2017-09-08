//
//  HGError.swift
//  HG_WeiCaiwu_swift
//
//  Created by 小雨很美 on 2017/8/11.
//  Copyright © 2017年 小雨很美. All rights reserved.
//

import Foundation
import Alamofire
struct HGError {
	var code: Int?
	var domain: String?
	var message: String?
	var url: URL?
	var error: Error?
	var aferror: AFError?

	init( error: Error) {
		if let aferror = error as? AFError {
			self.aferror = aferror
			switch aferror{
			case .invalidURL(url: let url):
				invalidURL(url)
			case .multipartEncodingFailed(reason: let reason):
				multipartEncodingFailed(reason)
			case .parameterEncodingFailed(reason: let reason):
				parameterEncodingFailed(reason)
			case .responseSerializationFailed(reason: let reason):
				responseSerializationFailed(reason)
			case .responseValidationFailed(reason: let reason):
				responseValidationFailed(reason)
			}
		} else {
			 let error = error as NSError
			self.error = error
			self.code = error.code
			self.domain = error.domain
			self.message = error.userInfo["NSLocalizedDescription"] as? String
			self.url = error.userInfo["NSErrorFailingURLKey"] as? URL
		}
	}

	init(code: Int? = nil, message: String? = nil) {
		self.code = code
		self.message = message
	}
}



// MARK: - 解析数据
extension HGError{
	static func anaysisData(_ data: Any?) -> HGError? {
		if let data = data as? Dictionary<String, Any>,let code = data["code"] as? Int {
			if code != 0{
				var hgError = HGError()
				hgError.code = code
				hgError.message = data["msg"] as? String
				return hgError
			}
		}
		return nil
	}
}
// MARK: - 序列化error
extension HGError{

	func invalidURL(_ url: URLConvertible)  {

	}
	func multipartEncodingFailed(_ reason: AFError.MultipartEncodingFailureReason)  {

	}
	func parameterEncodingFailed(_ reason: AFError.ParameterEncodingFailureReason)  {

	}

	/// 	序列化的过程中，可能会发生的错误
	///
	/// - Parameter reason: <#reason description#>
	mutating func responseSerializationFailed(_ reason: AFError.ResponseSerializationFailureReason)  {
		switch reason{
		case .inputDataNil, .inputDataNilOrZeroLength:
			//服务器返回的response没有数据或者数据的长度是0
			self.message = "服务器返回的response没有数据或者数据的长度是0"
		case .inputFileNil:
			//指向数据的URL不存在
			self.message = "指向数据的URL不存在"
		case .inputFileReadFailed(at: let url):
			// 指向数据的URL无法读取数据
			self.message = "指向数据的URL无法读取数据"
			self.url = url
		case .stringSerializationFailed(encoding: let encoding):
			self.message = "当使用指定的" + encoding.description + "序列化数据为字符串时，抛出的错误"
		case.jsonSerializationFailed(error: let error):
			//JSON序列化错误
			self.message  = "JSON序列化错误"
			self.error = error
		case .propertyListSerializationFailed(error: let error):
			self.message = "plist序列化错误"
			self.error = error
		}
	}
	func responseValidationFailed(_ reason: AFError.ResponseValidationFailureReason)  {

	}
}

