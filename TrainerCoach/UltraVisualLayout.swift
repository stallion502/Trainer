//
//  UltraVisualLayout.swift
//  TrainerCoach
//
//  Created by User on 07/08/2017.
//  Copyright © 2017 User. All rights reserved.
//

import Foundation

struct UltraVisualLayoutConstants {
    static let standartHeight: CGFloat = 120
    static let featuredHeight: CGFloat = 350
}

class UltraVisualLayout: UICollectionViewFlowLayout {
    
    let dragOffset: CGFloat = 180
    var myoffset = 0
    var minSpacingOffset = 0
    var cache = [UICollectionViewLayoutAttributes]()
    
    var featuredItemIndex: Int {
        get {
            return max(0, Int((collectionView?.contentOffset.y)! / dragOffset))
        }
    }
    
    var nextItemPercentageOffset: CGFloat {
        get {
            return (collectionView?.contentOffset.y)! / dragOffset - CGFloat(featuredItemIndex)
        }
    }
    
    var width: CGFloat {
        get {
            return (collectionView?.bounds.width)!
        }
    }
    
    var height: CGFloat {
        get {
            return (collectionView?.bounds.height)!
        }
    }
    
    var numberOfItems: Int {
        get {
            return (collectionView?.numberOfItems(inSection: 0))!
        }
    }
    
    override var collectionViewContentSize: CGSize {
        let contentHeight = (CGFloat(numberOfItems) * dragOffset) + (height - dragOffset)
        return CGSize(width: width, height: contentHeight)
    }
    
    
    override func prepare() {
        cache.removeAll(keepingCapacity: false)
        
        let standartHeight = UltraVisualLayoutConstants.standartHeight
        let featuredHeight = UltraVisualLayoutConstants.featuredHeight
        
        var frame = CGRect.zero
        var y: CGFloat = 0
        
        for item in 0..<numberOfItems {
            
            let indexPath = IndexPath(item: item, section: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.zIndex = item
            var height = standartHeight
            if indexPath.item == featuredItemIndex {
                
                let yOffset = standartHeight * nextItemPercentageOffset
                y = (collectionView?.contentOffset.y)! - yOffset
                height = featuredHeight
                
            } else if indexPath.item == (featuredItemIndex + 1) && indexPath.item != numberOfItems {
                
                let maxY = y  + standartHeight
                height = standartHeight + max((featuredHeight - standartHeight) * nextItemPercentageOffset, 0)
                y = maxY - height
            }
            frame = CGRect(x: 0, y: y, width: width, height: height)
            attributes.frame = frame
            cache.append(attributes)
            y = frame.maxY
        }
    }
    
    
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        let value = velocity.y > 0 ? 1 : -1
        myoffset += value
        if myoffset <= 0{
            myoffset = 0
            return CGPoint(x: proposedContentOffset.x, y: -48)
        }
        
        if myoffset >= (collectionView?.numberOfItems(inSection: 0))! - 1 {
            myoffset = (collectionView?.numberOfItems(inSection: 0))! - 1
        }
            return CGPoint(x: proposedContentOffset.x, y: CGFloat(-20 + 180 * myoffset))
    }
}
