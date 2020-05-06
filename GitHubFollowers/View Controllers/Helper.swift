//
//  Helper.swift
//  GitHubFollowers
//
//  Created by Yinan Qiu on 3/31/20.
//  Copyright © 2020 Yinan. All rights reserved.
//

import UIKit

enum Helper {
    static func createFlowLayout(in view: UIView) -> UICollectionViewFlowLayout {
        let screenWidth = view.bounds.width
        let padding: CGFloat = 12
        let gap: CGFloat = 10
        let colCount: CGFloat = 3
        let cellWidth = (screenWidth-(padding*2)-(gap*(colCount-1)))/colCount
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: cellWidth, height: cellWidth + 40)
        return flowLayout
    }
}
