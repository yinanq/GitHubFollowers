//
//  UITableView+Ext.swift
//  GitHubFollowers
//
//  Created by Yinan Qiu on 5/5/20.
//  Copyright © 2020 Yinan. All rights reserved.
//

import UIKit

extension UITableView {
    
    func removeExcessCells() {
        tableFooterView = UIView(frame: .zero)
    }
    
    // not used, kept for reference:
    func reloadDataOnMainThread() {
        DispatchQueue.main.async { self.reloadData() }
    }
    
}
