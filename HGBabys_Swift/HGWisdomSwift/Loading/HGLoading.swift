//
//  HGLoading.swift
//  BabysCard_Swift
//
//  Created by 小雨很美 on 2017/6/28.
//  Copyright © 2017年 小雨很美. All rights reserved.
//


import UIKit

public struct Delay {
    public static let short: TimeInterval = 2.0
    public static let long: TimeInterval = 3.5
}

open class HGLoading: Operation {

    // MARK: Properties

    public var text: String? {
        get { return self.view.text }
        set { self.view.text = newValue }
    }
    public var image: UIImage? {
        get { return self.view.image }
        set { self.view.image = newValue }
    }

    public var delay: TimeInterval
    public var duration: TimeInterval

    private var _executing = false
    override open var isExecuting: Bool {
        get {
            return self._executing
        }
        set {
            self.willChangeValue(forKey: "isExecuting")
            self._executing = newValue
            self.didChangeValue(forKey: "isExecuting")
        }
    }

    private var _finished = false
    override open var isFinished: Bool {
        get {
            return self._finished
        }
        set {
            self.willChangeValue(forKey: "isFinished")
            self._finished = newValue
            self.didChangeValue(forKey: "isFinished")
        }
    }


    // MARK: UI

    public var view: HGLoadingView = HGLoadingView()


    // MARK: Initializing

	public init(text: String? = nil, image: UIImage? = #imageLiteral(resourceName: "HGLoading"), delay: TimeInterval = 0, duration: TimeInterval = Delay.short) {
        self.delay = delay
        self.duration = duration
        super.init()
        self.image = image
        self.text = text
    }




    // MARK: Showing

    public func show() {
        HGLoadingCenter.default.add(self)
    }


    // MARK: Cancelling

    open override func cancel() {
        super.cancel()
        self.finish()
        self.view.removeFromSuperview()

    }


    // MARK: Operation Subclassing

    override open func start() {
        guard !self.isExecuting else { return }
        guard Thread.isMainThread else {
            DispatchQueue.main.async { [weak self] in
                self?.start()
            }
            return
        }
        super.start()
        setUserInteractionEnabled()
    }

    override open func main() {
        self.isExecuting = true

        DispatchQueue.main.async {
            self.view.setNeedsLayout()
            self.view.alpha = 1
            HGLoadingWindow.shared.addSubview(self.view)

        }
    }

    open func finish() {
        guard self.isExecuting else { return }
        self.isExecuting = false
        self.isFinished = true
        setUserInteractionEnabled()
    }

    func setUserInteractionEnabled()  {
        if HGLoadingCenter.default.currentLoading == nil{
            HGLoadingWindow.shared.isUserInteractionEnabled = false
        }else{
            HGLoadingWindow.shared.isUserInteractionEnabled = true
        }
    }

    //MARK: -
    class  func cancel(){
        HGLoadingCenter.default.currentLoading?.cancel()
    }
    class  func cancelAll(){
        HGLoadingCenter.default.cancelAll()
//        HGLoadingWindow.shared.isUserInteractionEnabled = false
    }

}



protocol Loading {
	func showLoading(message: String? )
	func endLoading()
}
extension UIViewController: Loading{
	func showLoading(message: String? = nil) {
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		HGLoading().show()
	}
	func endLoading() {
		UIApplication.shared.isNetworkActivityIndicatorVisible = false
		HGLoading.cancel()
	}
}

