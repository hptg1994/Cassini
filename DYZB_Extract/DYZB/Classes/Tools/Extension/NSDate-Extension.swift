//
//  NSDate-Extension.swift
//  DYZB
//
//  Created by 何品泰高 on 2018/11/17.
//  Copyright © 2018 何品泰高. All rights reserved.
//

import Foundation

extension NSDate {
   class func getCurrentTime() -> String {
        let nowDate = NSDate()
        let interval = Int(nowDate.timeIntervalSince1970)
        return "\(interval)"
    }
}
