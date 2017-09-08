//
//  BBWebViewController.swift
//  HGBabys_Swift
//
//  Created by 小雨很美 on 2017/9/2.
//  Copyright © 2017年 小雨很美. All rights reserved.
//

import UIKit
import WebKit

struct BBWebViewObserverKey {
	static let estimatedProgress = "estimatedProgress"
	static let isLoading = "loading"
}
class BBWebViewController: UIViewController {

	@IBOutlet weak var webProgressView: HGWebProgressView!
	@IBOutlet weak var webView: WKWebView!
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		requireData()
    }
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		addObserver()
		webViewLoadingStateChanged()
	}
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		removeObserver()
		UIApplication.shared.isNetworkActivityIndicatorVisible = false
	}


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	func requireData()  {
		if let url = URL(string: "https://www.jianshu.com/p/c9c021b70927"){
			let request = URLRequest(url: url)
			webView.load(request)
		}
	}
// MARK: -Observer
	func addObserver()  {
		webView.addObserver(self, forKeyPath: BBWebViewObserverKey.estimatedProgress, options: [.new, .old], context: nil)
		webView.addObserver(self, forKeyPath: BBWebViewObserverKey.isLoading, options: [.new, .old], context: nil)
	}
	func removeObserver()  {

		webView.removeObserver(self, forKeyPath: BBWebViewObserverKey.estimatedProgress)
		webView.removeObserver(self, forKeyPath: BBWebViewObserverKey.isLoading)
	}
	override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		switch keyPath {
		case BBWebViewObserverKey.estimatedProgress?:
			webViewProgressChanged()
		case BBWebViewObserverKey.isLoading?:
			webViewLoadingStateChanged()
		default:
			break
		}
	}
	func webViewProgressChanged()  {
		webProgressView.progress = webView.estimatedProgress
	}
	func webViewLoadingStateChanged()  {
	UIApplication.shared.isNetworkActivityIndicatorVisible = webView.isLoading
	}



    
 // MARK: - IBAction

	@IBAction func dismissButtonAction(_ sender: UIBarButtonItem) {
		dismiss(animated: true, completion: nil)
	}
	
	@IBAction func backButtonAction(_ sender: UIBarButtonItem) {
		if webView.canGoBack {
			webView.goBack()
		}else{
			dismiss(animated: true, completion: nil)
		}
	}
	
	@IBAction func leftEdgePanAction(_ sender: UIScreenEdgePanGestureRecognizer) {
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
extension BBWebViewController: WKNavigationDelegate{

}


