//
// Created by 何品泰高 on 2018/11/18.
// Copyright (c) 2018 何品泰高. All rights reserved.
//

import Foundation

// 9.15.3(4) 创建对应的Model --> 9.15.3(5) 创建对应的懒加载属性
class PageHeaderCycleModel:NSObject {
    @objc var title:String = ""
    @objc var pic_url:String = ""
    @objc var room:[String:NSObject]?{
        didSet {
            guard let room = room else { return }
            anchor = AnchorModal(dict: room)
        }
    }

    //主播信息对应的模型对象
    var anchor: AnchorModal?

    //MARK:- 自定义构造函数
    init(dict:[String:NSObject]){
        super.init()
        setValuesForKeys(dict)
    }

    override func setValue(_ value: Any?, forUndefinedKey key: String) { }


}
