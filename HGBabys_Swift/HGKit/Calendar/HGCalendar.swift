//
//  HGCalendar.swift
//  BabysCard_Swift
//
//  Created by 小雨很美 on 2017/6/29.
//  Copyright © 2017年 小雨很美. All rights reserved.
//

import UIKit
import SnapKit


public enum HGCalendarScope {
    case Month
    case Week
}

public enum HGCalendarTransition {
    case None
    case MonthToWeek
    case WeekToMonth
}
public enum HGCalendarTransitionState {
    case StateIdle
    case StateChanging
    case StateFinishing
}


class HGCalendar: UIView {

    //MARK: - 开放属性
	var headViewHeight: CGFloat = 0.0
	var weekViewHeight: CGFloat = 24.0

	var today:Date? = nil
	var minDate:Date? = nil
    var maxDate:Date? = nil

    let calculator: HGCalendarCalculator = {
        return HGCalendarCalculator()
    }()


    open var scrollDirection: UICollectionViewScrollDirection = .vertical {
		didSet{
			collectionLayout.scrollDirection = scrollDirection
		}
	}
	// default is UICollectionViewScrollDirectionVertical

    var  state: HGCalendarTransitionState = .StateIdle
    var scope: HGCalendarScope = .Month
    var transition:HGCalendarTransition = .None
	var  scopeLike: HGCalendarScope {
		get{
			if state == .StateChanging{
				return .Month
			} else {
				return scope
			}
		}
	}


	var  isPagingEnabled = true {
		didSet{
			collectionView.isPagingEnabled = isPagingEnabled
		}
	}


    weak open var delegate: HGCalendarDelegate?
    weak open var dateSource: HGCalendarDataSource?



//	 var monthViewHeight: CGFloat = 0
	 var weekRowViewHeight: CGFloat = 0

    //MARK: - 私有属性
	private var needUpdateHeight = true
	private var focuseRow: Int = 0 //切换 月 周 视图时焦点行
	private var focuseDate: Date? //切换 月 周 视图时焦点cell
     var collectionView: HGCalendarCollectionView
	
    private  var collectionLayout: HGCalendarCollectionViewLayout = {
		let layour = HGCalendarCollectionViewLayout()
        return layour
    }()

	private var weekdayView: HGCalendarWeekdayView?
	private var headView: HGCalendarHeadView?

	var currentPage: Date = Date()  {
		didSet{
			didSetCurrentPage(currentPage, false)
		}
	}

	private var selectedDates: [Date] = []




    //MARK: - 重写方法
    override init(frame: CGRect) {

        collectionView = HGCalendarCollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        super.init(frame: frame)
        configCollectionView()
    }


    required  init?(coder aDecoder: NSCoder) {
        collectionView = HGCalendarCollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        super.init(coder: aDecoder)
        configCollectionView()
    }



	override func layoutSubviews() {
		super.layoutSubviews()

		if needUpdateHeight == true {
			needUpdateHeight = false
			if self.scopeLike == .Month {
				weekRowViewHeight =  (frame.height - weekViewHeight - headViewHeight ) / 6
			}else{
				weekRowViewHeight = (frame.height - weekViewHeight - headViewHeight )
			}
			if today != nil{

				requestBoundingDatesIfNecessary()
				(_, currentPage)  = calculator.pageForSection((calculator.indexPathOfDate(today)?.section)!)
			}
		}




	}


    //MARK: - 私有方法
   private  func configCollectionView()  {

	collectionView.register(HGCalendarCell.self, forCellWithReuseIdentifier: "cell")
	collectionView.delegate = self
	collectionView.dataSource = self

	collectionView.allowsMultipleSelection = true
	calculator.calendar = self
	collectionLayout.calendar = self

	weekdayView = HGCalendarWeekdayView()
	weekdayView?.calendar = self

	headView = HGCalendarHeadView()

	isPagingEnabled = true


	addSubview(headView!)
	addSubview(weekdayView!)
	self.addSubview(collectionView)

	headView?.snp.makeConstraints { (make) in
		make.leading.trailing.top.equalTo(self)
		make.height.equalTo(headViewHeight)
	}
	weekdayView?.snp.makeConstraints { (make) in
		make.leading.trailing.equalTo(self)
		make.top.equalTo(headView!.snp.bottom)
		make.height.equalTo(weekViewHeight)
	}
	collectionView.snp.makeConstraints { (make) in
		make.leading.bottom.trailing.equalTo(self)
		make.top.equalTo(weekdayView!.snp.bottom)
	}

}

	//MARK: - 开放方法

	func reloadData() {
		collectionView.reloadData()
	}


}



//MARK: - UICollectionViewDelegate

extension HGCalendar: UICollectionViewDelegate{

	func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		let contentOffset = collectionView.contentOffset
		let centerPoint = CGPoint(x: contentOffset.x + collectionLayout.estimatedItemSize.width / 2 , y: collectionLayout.estimatedItemSize.height / 2)
		let centerIndexPath = collectionView.indexPathForItem(at: centerPoint)!

		(_, currentPage)  = calculator.pageForSection(centerIndexPath.section)
	}

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		collectionView.deselectItem(at: indexPath, animated: false)
		let cell  = collectionView.cellForItem(at: indexPath) as! HGCalendarCell
		guard cell.monthPosition == .Current else { return /*非当前月禁止点击*/}
		let (date, _) = self.calculator.dateForIndexPath(indexPath)
		guard date != nil else { return }
		if selectedDates.contains(date!) ,  let index = selectedDates.index(of: date!){
			selectedDates.remove(at: index)
		} else {
			selectedDates.append(date!)
		}
		cell.performSelecting(checkIfDateIsSelected(date))
    }

}

//MARK: - UICollectionViewDataSource
extension HGCalendar: UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        self.requestBoundingDatesIfNecessary()
        return self.calculator.numberOfSection
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		switch scopeLike {
		case .Month:
			return 42
		default:
			return 7
		}
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HGCalendarCell
		cell.monthPosition = calculator.monthPositionForIndexPath(indexPath)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let ccell = cell as? HGCalendarCell else { return }
		let  (date, _) = self.calculator.dateForIndexPath(indexPath)
		let chineseComp = self.calculator.gregorian.chineseDateComponents(date!)

		ccell.refreshCell(chineseComp)
		ccell.performSelecting(checkIfDateIsSelected(date))
    }
}



//MARK: - HGCalendarDelegate
@objc protocol HGCalendarDelegate: NSObjectProtocol {
    func hg_calender(_ calender: HGCalendar,boundingRectWillChange rect:CGRect, _ animated: Bool)
@objc optional	func hg_calendar(currentPageDidChange calender:HGCalendar)
}
//MARK: - HGCalendarDataSource
protocol HGCalendarDataSource: NSObjectProtocol {

    func hg_calenderMinDate(_ calender: HGCalendar) -> Date
    func hg_calenderMaxDate(_ calender: HGCalendar) -> Date

}





/// 周 月 切换
//MARK: - 周 月 切换
protocol CalendarSwitch {

}
extension HGCalendar: CalendarSwitch{

    @objc  func hg_handleScopeGesture(_ sender: UIPanGestureRecognizer) {

        switch sender.state {
        case .began:
            scopeTransitionDidBegin(sender)
            break
        case .changed:
            scopeTransitionDidUpdate(sender)
            break
        case .cancelled, .failed, .ended:
            scopeTransitionDidEnd(sender)
            break
        default:
            break
        }
    }


    //MARK: - scope
   private func scopeTransitionDidBegin(_ sender: UIPanGestureRecognizer)  {
		guard self.state == .StateIdle else { return }
        let velocit = sender.velocity(in: sender.view)//用来判断滑动方向
        switch scope {
        case .Month:
            if velocit.y < 0{
                self.state = .StateChanging
                self.transition = .MonthToWeek
            }
            break
        case .Week:
            if velocit.y > 0{
                self.state = .StateChanging
                self.transition = .WeekToMonth
            }
            break
        }
    guard self.state == .StateChanging else { return }

	prepareForAnimation()

    }
  private  func scopeTransitionDidUpdate(_ sender: UIPanGestureRecognizer) {
	guard self.state == .StateChanging else { return }

	let translation = sender.translation(in: sender.view).y
	let expandHeight = (self.scopeLike == .Month) ? weekRowViewHeight * 5.0 : 0
	switch self.transition {
	case .MonthToWeek:
		let progress: CGFloat = (expandHeight + translation) / (expandHeight)
		if translation <= 0 && translation >= -expandHeight {
			self.performPathAnimation(progress)
		}
	case .WeekToMonth:
		let progress: CGFloat = (translation ) / (expandHeight)
		if translation >= 0 && translation <= expandHeight  {
			self.performPathAnimation(progress)
		}
	default:
		break
	}
	}

 private   func scopeTransitionDidEnd(_ sender: UIPanGestureRecognizer)  {

	let velocit = sender.velocity(in: sender.view)//用来判断滑动方向

	if velocit.y < 0 || (velocit.y == 0 && self.transition == .MonthToWeek) {
		self.performPathAnimation(0)
		self.scope = .Week
	} else {
		self.performPathAnimation(1)
		self.scope = .Month
	}
	self.state = .StateFinishing
	reloadData()

	self.transition = .None
	self.state = .StateIdle

	performPathAnimation(1)
	(_, currentPage)  = calculator.pageForSection((calculator.indexPathOfDate(focuseDate)?.section)!)
	}


    //MARK: - 准备执行滑动
	func prepareForAnimation()  {
		focuseRow = getFocuseRow()

		reloadData()

		if self.transition == .WeekToMonth{

			(_, currentPage)  = calculator.pageForSection((calculator.indexPathOfDate(focuseDate)?.section)!)
			performPathAnimation(0)

		}


	}

   private  func performPathAnimation(_ progress: CGFloat)  {
	func updateTopOffset(){
		let topHeight = self.weekRowViewHeight * CGFloat(focuseRow - 1)
		let currentTopHeight = topHeight * (1 - progress)
		collectionView.setContentOffset(CGPoint(x: collectionView.contentOffset.x, y: currentTopHeight), animated: false)
	}

	///
	func updateCurrentHeight(){
		let expandHeight = (self.scopeLike == .Month) ? weekRowViewHeight * 5.0 : 0
		let currentHeight =  progress *  expandHeight + weekRowViewHeight + weekViewHeight + headViewHeight
		let  rect = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width:
			self.frame.width, height: currentHeight)
		delegate?.hg_calender(self, boundingRectWillChange: rect, true)
	}

	updateTopOffset()
	updateCurrentHeight()

	}
}


extension HGCalendar {

	func requestBoundingDatesIfNecessary() {
		if self.minDate == nil {
			self.minDate = self.dateSource?.hg_calenderMinDate(self)
			self.maxDate = self.dateSource?.hg_calenderMaxDate(self)
		}
	}

	func checkIfDateIsSelected(_ date: Date?) -> Bool {
		guard date != nil else { return false }
		if (today != nil && self.calculator.gregorian.isDate(date!, inSameDayAs: today!) || selectedDates.contains(date!) == true){
			return true;
		}
		return false
	}
	func getFocuseRow() -> Int {
		var dates: [Date] = selectedDates.reversed()
		if today != nil{ dates += [today!] }
		dates += [currentPage]

		var currentDates = [Date]();

		for date in dates {
			if (transition == .WeekToMonth && calculator.gregorian.isDate(date, inSameWeekAs: currentPage))||(transition == .MonthToWeek && calculator.gregorian.isDate(date, inSameMonthAs: currentPage)){
				currentDates.append(date)
			}
		}
		focuseDate = currentDates.first
		return self.calculator.gregorian.component(.weekOfMonth, from: focuseDate!)
	}



	func didSetCurrentPage(_ currentPage: Date, _ animated: Bool)  {
		requestBoundingDatesIfNecessary()
		if isDateInDifferentPage(currentPage) {
			scrollToPageForDate(currentPage, animated: animated)
			if (delegate?.responds(to: #selector(delegate?.hg_calendar(currentPageDidChange:))))!
			{
				delegate?.hg_calendar!(currentPageDidChange: self)
			}
		}
	}
	
	func scrollToPageForDate(_ pageDate: Date, animated: Bool)  {
		guard let currentSection = self.calculator.indexPathOfDate(pageDate)?.section else { return }
		collectionView.setContentOffset(CGPoint(x: CGFloat(currentSection) * collectionView.bounds.width, y: 0), animated: animated)
	}

	func isDateInDifferentPage(_ page: Date) -> Bool {
		switch scopeLike {
		case .Month:
			return calculator.gregorian.isDate(page, inSameMonthAs: currentPage)
		case .Week:
			return calculator.gregorian.isDate(page, inSameWeekAs: currentPage)
		}
	}
}




