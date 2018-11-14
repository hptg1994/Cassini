//
//  UIBarButtonItem-Extension.swift
//  DYZB
//
//  Created by 何品泰高 on 2018/11/13.
//  Copyright © 2018 何品泰高. All rights reserved.
//
import UIKit

extension UIBarButtonItem {
    /*class func createItem(imageName:String,highLightImageName:String,size:CGSize) -> UIBarButtonItem {
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), for: .normal)
        btn.setImage(UIImage(named: highLightImageName), for: .normal)
        btn.frame = CGRect(origin: .zero, size:size)
        return UIBarButtonItem(customView: btn)
    }*/

    // 使用构造函数来代替createItem这个方法(便利构造函数) 必须明确调用一个设计的构造函数（如上面的UIBarButtonItem(customView: btn)）
    convenience init(imageName:String,highLightImageName:String = "",size:CGSize = .zero) {

        // 1.创建UIButton
        let btn = UIButton()

        // 2.设置btn图片
        btn.setImage(UIImage(named: imageName), for: .normal)
        if highLightImageName != ""{
            btn.setImage(UIImage(named: highLightImageName), for: .highlighted)
        }

        // 3.设置btn尺寸
        if size == .zero {
            btn.sizeToFit()
        }else{
            btn.frame = CGRect(origin: .zero, size: size)
        }

        // 4.创建UIBarButtonItem
        self.init(customView: btn)
    }

}
