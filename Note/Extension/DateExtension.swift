//
//  DateExtension.swift
//  Note
//
//  Created by yck on 2016/11/25.
//  Copyright © 2016年 MyNote. All rights reserved.
//

import Foundation

extension Date {
    
    static func getCurrentTimeString() -> String {
        
        let date = Date()
        let calendar = Calendar(identifier: .chinese)
        
        let components = calendar.dateComponents(in: .current, from: date)
        let year = components.year
        let month = components.month
        let day = components.day
        let hour = components.hour
        let minute = components.minute
        let second = components.second
        
        return "\(year!)年\(month!)月\(day!)日\(hour!)时\(minute!)分\(second!)秒"
    }
}
