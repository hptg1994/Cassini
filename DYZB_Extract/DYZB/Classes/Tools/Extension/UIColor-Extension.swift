//
// Created by 何品泰高 on 2018/11/14.
// Copyright (c) 2018 何品泰高. All rights reserved.
//

import UIKit

extension  UIColor {

    // 自定义的constructor
    convenience init(r:CGFloat,g:CGFloat,b:CGFloat){
        self.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
    }

    class func randomColor() -> UIColor {
        return UIColor(r: CGFloat(arc4random_uniform(256)), g: CGFloat(arc4random_uniform(256)), b: CGFloat(arc4random_uniform(256)))
    }
}
