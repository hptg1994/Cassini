//
//  GamePageModel.swift
//  DYZB
//
//  Created by 何品泰高 on 2018/11/20.
//  Copyright © 2018 何品泰高. All rights reserved.
//

import Foundation

// 11.3 创建这个View对应的ViewModal --> 11.4 在GameViewModel中保存这个模型
// 当这个做完后发现，这个和AnchorGroup的结构有点相似，所以我们给他们抽取一个父Model ---> 11.5 抽取BaseGameModel ---> 11.6 让AnchorGroup和GamePageModel继承BaseGameModel
class GamePageModel:BaseGameModel {
    
    /*
    var tag_name:String = ""
    var pic_url : String = ""
    init(dict:[String :Any]){
        super.init()
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    */
    
}
