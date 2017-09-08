//
//  HGCalendarWeekdayView.swift
//  BabysCard_Swift
//
//  Created by 小雨很美 on 2017/7/18.
//  Copyright © 2017年 小雨很美. All rights reserved.
//

import UIKit
import SnapKit
class HGCalendarWeekdayView: UIView {


	weak var calendar: HGCalendar?{
		didSet{
			makeView()
		}
	}
	let stackView = UIStackView()

	var weekCellViews = [WeekdayCell]()

	override init(frame: CGRect) {
		super.init(frame: frame)
		config()
//		makeView()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		config()
//		makeView()
	}
	func config() {
		self.backgroundColor = #colorLiteral(red: 1, green: 0.7332356333, blue: 0.9982175544, alpha: 1)
	}

	func makeView()  {

		stackView.axis = .horizontal
		/*alignment 属性指定了子视图在布局方向上的对齐方式，如果值是 Fill 则会调整子视图以适应空间变化，其他的值不会改变视图的大小。有效的值包含：Fill、 Leading、 Top、 FirstBaseline、 Center、 Trailing、 Bottom、 LastBaseline。*/
		stackView.alignment = .fill
		/*Distribution 属性定义了 subviews 的分布方式，可以赋值的5个枚举值可以分为两组： Fill 组 和 Spacing 组。

		Fill 组用来调整 subviews 的大小，同时结合 spacing 属性来确定 subviews 之间的间距。

		Fill: subviews 将会根据自己内容的内容阻力（content resistance）或者内容吸附优先级（hugging priority）进行动态拉伸，如果没有设置该值，subviews 中的一个子视图将会用来填充剩余可用空间。
		FillEqually: 忽略其他的约束，subviews 将会在设置的布局方向上等宽或等高排列。
		FillProportionally: subviews 将会根据自己的原始大小做适当的布局调整。
		Spacing 组指定了 subviews 在布局方向上的间距填充方式，当 subviews 不满足布局条件或有不明确的的 Auto Layout 设置时，该类型的值就会结合相应的压缩阻力（compression resistance） 来改变 subviews 的大小。

		EqualSpacing: subviews 等间距排列
		EqualCentering: 在布局方向上居中的 subviews 等间距排列*/
		stackView.distribution = .fillEqually

		/*spacing 属性根据当前 distribution 属性的值有不同方向的解释。

		如果 UIStackView 的 distribution 属性设置的是 EqualSpacing、 EqualCentering，spacing 属性指的就是 subviews 之间的最小间距。相反如果设置的是 FillProportionally 属性，那么 spacing 的值就是严格的间距值。*/
		//stackView.spacing = 7
		addSubview(stackView)
		stackView.snp.makeConstraints { (make) in
			make.edges.equalTo(self)
		}

//		print(self.calendar!.calculator.gregorian.weekdaySymbols)
//		print(self.calendar!.calculator.gregorian.shortWeekdaySymbols)
//		print(self.calendar!.calculator.gregorian.veryShortWeekdaySymbols)
//
//		print(self.calendar!.calculator.gregorian.standaloneWeekdaySymbols)
//		print(self.calendar!.calculator.gregorian.shortStandaloneWeekdaySymbols)
//		print(self.calendar!.calculator.gregorian.veryShortStandaloneWeekdaySymbols)



		for week in (self.calendar?.calculator.gregorian.veryShortStandaloneWeekdaySymbols)! {
			let cellView  = createCellView(week)
			weekCellViews.append(cellView)
			stackView.addArrangedSubview(cellView)
		}

	}

	func createCellView(_ title: String) -> WeekdayCell {
		let cellView = WeekdayCell()
		cellView.titleLabel.text = title
		return cellView
	}
}

class WeekdayCell: UIView {
	let titleLabel: UILabel = {
		let label = UILabel()
		label.textAlignment = .center
		label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
		return label
	}()

	override init(frame: CGRect) {
		super.init(frame: frame)
		makeView()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		makeView()
	}
	func makeView ()  {
		addSubview(titleLabel)
		titleLabel.snp.makeConstraints { (make) in
			make.center.equalTo(self)
		}
	}

}
