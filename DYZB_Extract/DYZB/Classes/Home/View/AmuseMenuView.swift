//
//  AmuseMenuView.swift
//  DYZB
//
//  Created by 何品泰高 on 2018/11/22.
//  Copyright © 2018 何品泰高. All rights reserved.
//

import UIKit


// 12.4 娱乐界面顶部组件的开发 --> 12.4.1 创建xib来构建界面(记得在xib属性界面中把autoResizing给去掉) --> 12.4.2 xib快速创建启动类的方法
class AmuseMenuView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
}

// 12.4.2 xib快速创建启动类的方法 --> 12.4.3 在对应的控制器中添加懒加载
extension AmuseMenuView {
    class func amuseMenuView() -> AmuseMenuView {
        return Bundle.main.loadNibNamed("AmuseMenuView", owner: nil,options: nil)?.first as! AmuseMenuView
    }
}
