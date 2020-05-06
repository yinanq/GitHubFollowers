//
//  Date+Ext.swift
//  GitHubFollowers
//
//  Created by Yinan Qiu on 5/3/20.
//  Copyright © 2020 Yinan. All rights reserved.
//

import Foundation

extension Date {
    func convertToMonthYearFormat() -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MMM yyyy" //https://www.nsdateformatter.com
        return dateformatter.string(from: self)
    }
}
