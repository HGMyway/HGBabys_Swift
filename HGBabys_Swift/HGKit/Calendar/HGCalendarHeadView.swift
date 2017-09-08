//
//  HGCalendarHeadView.swift
//  BabysCard_Swift
//
//  Created by 小雨很美 on 2017/7/18.
//  Copyright © 2017年 小雨很美. All rights reserved.
//

import UIKit

class HGCalendarHeadView: UIView {


	//共有属性
	weak var calendar: HGCalendar?{
		didSet{
			makeView()
		}
	}
	//私有属性
	private let contentView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
	private var flowLayout: UICollectionViewFlowLayout  {
		get{
			return contentView.collectionViewLayout as! UICollectionViewFlowLayout
		}
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		config()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		config()
	}
	func config() {
		self.backgroundColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
		flowLayout.scrollDirection = .horizontal
	}
	func makeView() {

	}
}
