//
//  BaseGameModel.swift
//  DYZB
//
//  Created by 何品泰高 on 2018/11/20.
//  Copyright © 2018 何品泰高. All rights reserved.
//

import Foundation


// 11.5 抽取BaseGameModel --> 11.6 让AnchorGroup和GamePageModel继承BaseGameModel --> 11.7 调用这个Model
class BaseGameModel: NSObject {
    @objc var tag_name:String = ""
    @objc var icon_url : String = ""

    // 自定义构造函数
    init(dict:[String :Any]){
        super.init()
        setValuesForKeys(dict)
    }

    override init(){}
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}
