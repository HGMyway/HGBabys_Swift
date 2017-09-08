
//
//  HGLoadingCenter.swift
//  BabysCard_Swift
//
//  Created by 小雨很美 on 2017/6/29.
//  Copyright © 2017年 小雨很美. All rights reserved.
//

import UIKit

open class HGLoadingCenter {

    // MARK: Properties

    private let queue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()

    open var currentLoading: HGLoading? {
        return self.queue.operations.first as? HGLoading
    }

    open static let `default` = HGLoadingCenter()


    // MARK: Initializing

    init() {

//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(self.deviceOrientationDidChange),
//            name: .UIDeviceOrientationDidChange,
//            object: nil
//        )
    }

    

    // MARK: Adding Toasts

    open func add(_ loading: HGLoading) {
        self.queue.addOperation(loading)
    }


    // MARK: Cancelling Toasts

    open func cancelAll() {
        self.queue.cancelAllOperations()
//        for loading in self.queue.operations {
//            loading.cancel()
//        }
    }



//    // MARK: Notifications
//
//    @objc dynamic func deviceOrientationDidChange() {
//        if let lastLoading = self.queue.operations.first as? HGLoading {
//            lastLoading.view.setNeedsLayout()
//        }
//    }

}
