//
//  CollectionNormalCell.swift
//  DYZB
//
//  Created by 何品泰高 on 2018/11/16.
//  Copyright © 2018 何品泰高. All rights reserved.
//

import UIKit
import Kingfisher

//6.7 定义cell的内容 ---> 6.7.1 同样先布局好xib ---> 6.7.2 注册Cell ---> 8.1.1定义模型属性
class CollectionNormalCell: CollectionBaseCell {

    //MARK:- 拖拽过来的属性(和LargerCell的y做法一样)
    @IBOutlet weak var roomNameLabel: UILabel!

    // 8.1.1定义模型属性 ---> 8.1.2回RecommandViewController去传值 + // 8.6 更改被继承控件中的anchor至override
    override var anchor: AnchorModal? {
        // 8.4 设置内容
        didSet {
            // 8.6.1 将这个anchor 传递给父类anchor ---> 8.6.2 LargerCell中如法炮制
            super.anchor = anchor
            // 4.显示房间名称，干完这一步后就能差不多完成了，现在来优化 ---> 8.5 提取相同的部分到单独一个文件
            roomNameLabel.text = anchor?.room_name
        }
    }

}
