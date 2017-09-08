//
//  HGCalendarCollectionViewLayout.swift
//  BabysCard_Swift
//
//  Created by 小雨很美 on 2017/6/29.
//  Copyright © 2017年 小雨很美. All rights reserved.
//

import UIKit

class HGCalendarCollectionViewLayout: UICollectionViewLayout {


    //MARK: - 开放属性
    weak var calendar: HGCalendar?
    var scrollDirection: UICollectionViewScrollDirection = .vertical
    var  sectionInsets: UIEdgeInsets  = .zero


	 var estimatedItemSize: CGSize = .zero
    //MARK: - 私有属性

//  private  var widths: [CGFloat] = []
//   private var heights: [CGFloat] = []
    private var lefts: [CGFloat] = []
    private var tops: [CGFloat] = []
    private var contentsSize: CGSize = .zero
    private var itemAttributes: [IndexPath : UICollectionViewLayoutAttributes] = [:]



    //MARK: - 重写方法
    override func prepare() {
        super.prepare()
        //计算item size
        self.itemAttributes.removeAll()
        lefts.removeAll()
        tops.removeAll()

        self.contentsSize = getContentSize()
        self.estimatedItemSize = self.getEstimatedItemSize()
        setTops()
        setLefts()

    }
    override var collectionViewContentSize: CGSize{
        get{
            return self.contentsSize
        }
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

      let  interRect = rect.intersection(CGRect(x: 0, y: 0, width: self.contentsSize.width, height:self.contentsSize.height))
        if interRect.isEmpty == true  {
            return nil
        }

        var layoutAttributes: [UICollectionViewLayoutAttributes] = []

        switch self.scrollDirection {
        case .horizontal:
            let wholeSections: Int  =  Int(interRect.width / self.collectionView!.bounds.width)
            var numberOfColumns = wholeSections * 7

            let numberOfRows = self.calendar?.calculator.calendarScopeLike == .Month ? 6 : 1

            let startSection: Int =  Int(interRect.origin.x / self.collectionView!.bounds.width)

            let widthDetal1 =  fmod(interRect.minX, (self.collectionView?.bounds.width)!) - self.sectionInsets.left

            let columnCountDetal1: Int  = Int(floor(widthDetal1 / estimatedItemSize.width))
            numberOfColumns += (7 - columnCountDetal1) % 7

            let  startColumn  = startSection * 7 + columnCountDetal1 % 7
            var widthDetal2 = fmod(interRect.maxX, (self.collectionView?.bounds.width)! - sectionInsets.left)
            widthDetal2 = max(0, widthDetal2)

            let columnCountDetail2: Int = Int(ceil(widthDetal2 / estimatedItemSize.width))
            numberOfColumns += columnCountDetail2 % 7
            let endColum = startColumn + numberOfColumns - 1
            for cindex in startColumn...endColum{
                for rindex in 0...numberOfRows - 1{
                    let section = cindex / 7
                    let item = cindex % 7 + rindex * 7
                    let indexPath  = IndexPath(item: item, section: section)
                    let itemAttributes = self.layoutAttributesForItem(at: indexPath)
                    layoutAttributes.append(itemAttributes!)
                }
            }
            break
        case .vertical:

            let wholeSections: Int = Int(interRect.height / self.collectionView!.bounds.height)
            var numberOfRows = wholeSections * 6
            let startSection = interRect.origin.y / self.collectionView!.bounds.height
            var heightDetail1 = fmod(interRect.minY, self.collectionView!.bounds.height) - self.sectionInsets.top
            heightDetail1 = max(0, heightDetail1)

            let rowCountDetail1 = floor(heightDetail1 / estimatedItemSize.height)
            numberOfRows  +=  Int((6 - rowCountDetail1).truncatingRemainder(dividingBy: 6))
            let startRow: Int = (Int(startSection * 6 + rowCountDetail1.truncatingRemainder(dividingBy: 6)) )

            var heightDetail2  = fmod(interRect.maxX, self.collectionView!.bounds.height)
            heightDetail2 = max(0, heightDetail2 - self.sectionInsets.bottom)
            let rowCountDetail2: Int = Int(ceil(heightDetail2 / estimatedItemSize.height))
            numberOfRows += rowCountDetail2

            let endRow: Int = startRow + numberOfRows - 1

            for rindex in startRow...endRow{
                for cindex in 0...numberOfRows - 1{
                    let section = rindex / 6
                    let item = cindex + (rindex % 6) * 7
                    let indexPath  = IndexPath(item: item, section: section)
                    let itemAttributes = self.layoutAttributesForItem(at: indexPath)
                    layoutAttributes.append(itemAttributes!)
                }
            }
            break
        }
        return layoutAttributes
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attributes = self.itemAttributes[indexPath] else {
            let attributes = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)

            let (column, row) = self.coordinateFor(indexPath)

            var x:CGFloat = 0.0
            var y:CGFloat = 0.0

            switch self.scrollDirection {
            case .horizontal:
                x = self.lefts[row] + CGFloat(indexPath.section) * (self.collectionView?.bounds.width)!
                y = self.tops[column]
                break
            case .vertical:
                x = self.lefts[row]
                y = self.tops[column] + CGFloat(indexPath.section) * (self.collectionView?.bounds.height)!
                break

            }
            let frame = CGRect(x: x, y: y, width: self.estimatedItemSize.width, height: self.estimatedItemSize.height)
            attributes.frame = frame
            self.itemAttributes[indexPath] = attributes
            return attributes
        }

        return attributes
    }


}




//MARK: - 私有方法
extension HGCalendarCollectionViewLayout
{


    /// 获取item的行列位置
    ///
    /// - Parameter indexPath: <#indexPath description#>
    /// - Returns: 元组 item的行列属性
    private  func coordinateFor(_ indexPath: IndexPath) ->(Int,Int) {
        return  (indexPath.item / 7 , indexPath.item % 7)
    }

   private func getEstimatedItemSize() -> CGSize {
        let width = ((collectionView?.bounds.width)! - sectionInsets.left - sectionInsets.right)/7.0
        let height: CGFloat = getRowHeight()
        return CGSize(width: width, height: height)
    }
   private func getRowHeight() -> CGFloat {
        
        switch self.calendar!.calculator.calendarScopeLike {
        case .Month:
            return contentsSize.height / 6
        case .Week:
            return contentsSize.height
        }
    }

   private func setTops ()  {
        tops.append(self.sectionInsets.top)
        if self.calendar!.calculator.calendarScopeLike == .Month {
            for index  in 1...5 {
                tops.append(tops[index - 1] + self.estimatedItemSize.height)
            }
        }
    }
   private func setLefts ()  {
        lefts.append(self.sectionInsets.left)
        for index in 1...6 {
            lefts.append(lefts[index - 1] + self.estimatedItemSize.width)
        }
    }

    private  func  getContentSize() -> CGSize {
        var  width = self.collectionView!.bounds.width
        var height: CGFloat

        if self.calendar?.calculator.calendarScopeLike  == .Month{
            height = (self.calendar?.weekRowViewHeight)! * 6
        }else{
			height = (self.calendar?.weekRowViewHeight)!
        }

        if self.scrollDirection == .horizontal{
            width *= CGFloat((self.collectionView?.numberOfSections)!)
        }else{
            height *= CGFloat((self.collectionView?.numberOfSections)!)
        }
        let size: CGSize = CGSize(width: width, height: height)
        return size
    }
}





