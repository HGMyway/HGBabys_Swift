//
//  FSCalendarCalculator.swift
//  BabysCard_Swift
//
//  Created by 小雨很美 on 2017/7/3.
//  Copyright © 2017年 小雨很美. All rights reserved.
//

import Foundation

class HGCalendarCalculator: NSObject {

//    override func forwardingTarget(for aSelector: Selector!) -> Any? {
//        if self.calendar?.responds(to: aSelector) {
//            return self.calendar
//        }
//        return super.forwardingTarget(for: aSelector)
//    }

    weak var calendar: HGCalendar?

    var gregorian: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
		calendar.locale = Locale(identifier: "zh_CN")
//		calendar.timeZone = TimeZone(secondsFromGMT: 8)!
//        calendar.firstWeekday = 7
        return calendar
    }()

	var chinese: Calendar = {
		var calendar = Calendar(identifier: .chinese)
		calendar.locale = Locale(identifier: "zh_CN")
		//        calendar.firstWeekday = 7
		return calendar
	}()

    var calendarScopeLike: HGCalendarScope {
        get{
			return (self.calendar?.scopeLike)!;
        }
    }


    var minDate: Date? {
        get{
            return self.calendar?.minDate
        }
    }
    var maxDate: Date? {
        get{
            return self.calendar?.maxDate
        }
    }

    var numberOfMonth: Int {
        get{
            return self.gregorian.dateComponents([.month], from: self.gregorian.firstDayOfMonth(self.minDate)!, to: self.gregorian.firstDayOfMonth(self.maxDate)!).month! + 1
        }
    }
    var numberOfWeek: Int {
        get{
            return self.gregorian.dateComponents([.weekOfYear], from: self.gregorian.firstDayOfWeek(self.minDate)!, to: self.gregorian.firstDayOfWeek(self.maxDate)!).weekOfYear! + 1
        }
    }


    var numberOfSection: Int {
        get{
            if self.calendarScopeLike ==  .Month{
                return numberOfMonth
            }else{
                return numberOfWeek
            }

        }
    }





	/// 获取indexPath对应的日期和日期组件
	///
	/// - Parameter indexPath: <#indexPath description#>
	/// - Returns: <#return value description#>
	func dateForIndexPath(_ indexPath: IndexPath) -> (Date?, DateComponents?) {

		func tuples(_ date: Date) ->  (Date?, DateComponents?){

			let dateComp = gregorian.dateComponents([.year ,.month ,.day ,.weekday], from: date)

			return (date, dateComp)
		}

		if self.calendarScopeLike == .Month{
			let (headDate , _) = self.monthHeadForSection(indexPath.section)
			if let date =  self.gregorian.date(byAdding: .day, value: indexPath.item, to: headDate){
				return tuples(date)
			}
		}else{
			let (weekDate, _) = self.weekHeadForSection(indexPath.section)

			if let  date = self.gregorian.date(byAdding: .day, value: indexPath.item, to: weekDate){
				return tuples(date)
			}
		}
		return (nil, nil)
	}


	func pageForSection(_ section: Int) -> (date: Date, page: Date) {
		if calendar?.scopeLike == .Month {
			return monthHeadForSection(section)
		}else{
			return weekHeadForSection(section)
		}

	}

    ///  周模式中一个月的第一天
    ///
    /// - Parameter section: <#section description#>
    /// - Returns: 第一个数据时星期模式中一周的第一天，第二个数据是本周中包含的1号
	func weekHeadForSection(_ section: Int) -> (date: Date, page: Date) {
        let week = self.gregorian.firstDayOfWeek(self.minDate)
        let firstDay = self.gregorian.date(byAdding: .weekOfYear, value: section, to: week!)!

		let lastDayOfWeek = gregorian.date(byAdding: .day, value: 6, to: firstDay)!


		if gregorian.isDate(firstDay, inSameMonthAs: lastDayOfWeek) {
			return (firstDay, firstDay)
		}else{
			var dayComp = gregorian.dateComponents([.year, .month, .day, .hour ], from: lastDayOfWeek)
			dayComp.day! = 1;
			let day = gregorian.date(from: dayComp)!
			return (firstDay, day)
		}
    }



    /// 月模式中一个月的第一天
    ///
    /// - Parameter section: <#section description#>
    /// - Returns: 元组第一个数据是月视图中的第一个item，第二个数据是一个月的第一号
    func monthHeadForSection(_ section: Int) -> (Date, Date) {
         var month = self.gregorian.firstDayOfMonth(self.minDate)!
        month = self.gregorian.date(byAdding: .month, value: section, to: month)!
        let numberOfHeadPlaceholders = self.numberOfHeadPlaceholdersForMonth(month: month)

		return ( self.gregorian.date(byAdding: .day, value: -numberOfHeadPlaceholders, to: month)!, month)
    }



	/// 月模式1号之前的天数
	///
	/// - Parameter month: <#month description#>
	/// - Returns: <#return value description#>
	private  func numberOfHeadPlaceholdersForMonth(month: Date) -> Int {
        let currentWeedday = self.gregorian.component(.weekday, from: month)
        return (currentWeedday - self.gregorian.firstWeekday + 7)  % 7
    }



	/// date对应的indexPath
	///
	/// - Parameter date: <#date description#>
	/// - Returns: <#return value description#>
	func indexPathOfDate(_ date: Date?) -> IndexPath? {
		guard date != nil else { return nil }

		switch self.calendar!.scopeLike {
		case .Month:
			let comp =	self.gregorian.dateComponents([ .month], from: self.gregorian.firstDayOfMonth(self.minDate)!, to: date!)
			let (firstDay, _) = monthHeadForSection(comp.month!)
			let item	= self.gregorian.dateComponents([.day], from: firstDay, to: date!).day
			return IndexPath(item: item!, section: comp.month!)
		case .Week:
			let comp =	self.gregorian.dateComponents([.day], from: self.gregorian.firstDayOfWeek(date)!, to: date!)
			let weekOfYear1 = gregorian.component(.weekOfYear, from: gregorian.firstDayOfWeek(minDate)!)
			let weekOfYear2 = gregorian.component(.weekOfYear, from: gregorian.firstDayOfWeek(date)!)

			return IndexPath(item: comp.day!, section: weekOfYear2 - weekOfYear1)
		}
	}


	/// 月份1号前几天
	///
	/// - Parameter indexPath: indexpath
	/// - Returns: hgcaposition
	func monthPositionForIndexPath(_ indexPath: IndexPath) -> HGCalendarMonthPosition {

		if calendar?.scopeLike == .Week {
			return .Current
		}
		let (date, _) = dateForIndexPath(indexPath)
		guard date != nil else { return .NotFound }
		let (_ , page) = pageForSection(indexPath.section)
		let com = gregorian.compare(date!, to: page, toGranularity: .month)
		switch com {
		case .orderedAscending:
			return .Previous
		case .orderedSame:
			return .Current
		case .orderedDescending:
			return .Next
		}
	}

}

extension Calendar{
	public func isDate(_ date1: Date, inSameWeekAs date2: Date) -> Bool {
		return self.component(.weekOfYear, from: date1) == component(.weekOfYear, from: date2)
	}
	public func isDate(_ date1: Date, inSameMonthAs date2: Date) -> Bool {
		return self.component(.month, from: date1) == component(.month, from: date2)
	}

    func firstDayOfMonth(_ month: Date?) -> Date? {
        guard month != nil else { return nil }
        var components  = self.dateComponents([.year, .month, .day, .hour], from: month!)
        components.day = 1
        return self.date(from: components)
    }

    func lastDayOfMonth(_ month: Date?) -> Date? {
        guard month != nil else { return nil }
        var components  = self.dateComponents([.year, .month, .day, .hour], from: month!)
        components.month = components.month! + 1
        components.day = 0
        return self.date(from: components)
    }
    func firstDayOfWeek(_ week: Date?) -> Date? {
        guard week != nil else { return nil }
        var components  = self.dateComponents([.year, .month, .day, .hour, .weekday], from: week!)

        components.day =  components.day!  -  (components.weekday! - self.firstWeekday + 7) % 7
        return self.date(from: components)
    }

    func lastDayOfWeek(_ week: Date?) -> Date? {
        guard week != nil else { return nil }
        var components  = self.dateComponents([.year, .month, .day, .hour, .minute, .weekday], from: week!)
        components.day =  components.day!  -  (components.weekday! - self.firstWeekday + 7) % 7 + 6
        return self.date(from: components)
    }

	/// 一个月有多少星期
	///
	/// - Parameter month: <#month description#>
	/// - Returns: <#return value description#>
	func numberOfWeeks(_ month: Date) -> Int {
		return self.component(.weekOfMonth, from: self.lastDayOfMonth(month)!)
	}
    
}

extension Date
{
	func zero() -> Date {
		return Calendar(identifier: .gregorian).date(bySettingHour: 0, minute: 0, second: 0, of: self )!
	}
	func formatString(_ format: String = "yyyy-MM-dd") -> String {
		let formatter = DateFormatter()
		formatter.dateFormat = format
		return formatter.string(from: self)
	}
}


public struct ChineseDateComponents {
	public var year: Int?
	public var month: Int?
	public var day: Int?
	public var hour: Int?
	public var minute: Int?
	public var weekDay: Int?

	public var chineseYear: Int?
	public var chineseMonth: Int?
	public var chineseDay: String?
	public var chineseHour: Int?
	public var chineseMinute: Int?

	public init(_ dateComp: DateComponents = DateComponents(), _ chineseDateComp: DateComponents = DateComponents()) {
		year = dateComp.year
		month = dateComp.month
		day = dateComp.day
		hour = dateComp.hour
		minute = dateComp.minute
		weekDay = dateComp.weekday

		chineseYear = chineseDateComp.year
		chineseMonth = chineseDateComp.month
		if chineseDateComp.day != nil {
			chineseDay = lunarChars[chineseDateComp.day! - 1]
			if chineseDateComp.day == 1 {
				chineseDay = months[chineseDateComp.month! - 1] + "月"
				if chineseDateComp.isLeapMonth!{
					chineseDay = "润" + chineseDay!
				}
			}
		}

	}

	let months = ["一","二","三","四","五","六","七","八","九","十","十一","十二"]

	let lunarChars = ["初一", "初二", "初三", "初四", "初五", "初六", "初七", "初八", "初九", "初十", "十一", "十二", "十三", "十四", "十五", "十六", "十七", "十八", "十九", "二十", "二一", "二二", "二三", "二四", "二五", "二六", "二七", "二八", "二九", "三十"]

}

extension Calendar{
	public func chineseDateComponents(_ date: Date) -> ChineseDateComponents{

		let chinese: Calendar = {
			var calendar = Calendar(identifier: .chinese)
//			calendar.locale = Locale(identifier: "zh_CN")
			calendar.locale = self.locale
			calendar.timeZone = self.timeZone;
			return calendar
		}()

		let dateComp  = self.dateComponents([.year, .month, .day, .hour, .minute, .weekday], from: date)
		let chineseDateComp  = chinese.dateComponents([.year, .month, .day, .hour, .minute, .weekday], from: date)
		return ChineseDateComponents(dateComp, chineseDateComp)
	}

}

