//
//  HGCalendarCell.swift
//  BabysCard_Swift
//
//  Created by 小雨很美 on 2017/6/29.
//  Copyright © 2017年 小雨很美. All rights reserved.
//

import UIKit
import SnapKit


public enum HGCalendarMonthPosition {
	case Previous
	case Current
	case Next
	case NotFound
}


class HGCalendarCell: UICollectionViewCell {

	var monthPosition: HGCalendarMonthPosition = .NotFound {
		didSet{
			refreshCellState()
		}
	}


	var cellDateCom: DateComponents?

	var isSelectedCell: Bool?

	open var custtomSelectedBackgroundView: UIView?

	


    let titleLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
	let subTitleLabel : UILabel = {
		let label = UILabel()
		label.numberOfLines = 0
		label.font = UIFont.systemFont(ofSize: 9)
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

   private  func makeView()  {

	backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

	custtomSelectedBackgroundView = UIView()
	custtomSelectedBackgroundView?.backgroundColor = #colorLiteral(red: 1, green: 0.7332356333, blue: 0.9982175544, alpha: 1)
	self.contentView.addSubview(custtomSelectedBackgroundView!)
	custtomSelectedBackgroundView?.snp.makeConstraints({ (make) in
		make.edges.equalToSuperview()
	})
	
	self.contentView.addSubview(titleLabel)
	titleLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
	}
	self.contentView.addSubview(subTitleLabel)
	subTitleLabel.snp.makeConstraints { (make) in
		make.centerX.equalToSuperview()
		make.top.equalTo(titleLabel.snp.bottom)
	}

	}


}

extension HGCalendarCell: CellRefresh
{
    func refreshCell(_ data: Any?) {

		if let chineseComp = data as? ChineseDateComponents {
			titleLabel.text = String(chineseComp.day!)
			subTitleLabel.text = chineseComp.chineseDay
		}

        guard  let dateCom = data as? DateComponents   else { return }
		cellDateCom = dateCom
        titleLabel.text =  String( dateCom.day!)


    }
	func performSelecting(_ selected: Bool) {
		var vSelected = selected
		if monthPosition != .Current { vSelected = false }
		isSelectedCell = vSelected
		custtomSelectedBackgroundView?.isHidden = !vSelected
	}
	func refreshCellState()  {
		switch monthPosition {
		case .Current:
			titleLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
		default:
			titleLabel.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
		}
		subTitleLabel.textColor = titleLabel.textColor
	}
}

