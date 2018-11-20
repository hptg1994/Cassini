//
// Created by 何品泰高 on 2018/11/17.
// Copyright (c) 2018 何品泰高. All rights reserved.
//

import Foundation

/// P:S 在11.6的时候令这个继承了BaseGameModel(旧的写的方式看备份文件)
class AnchorGroup: BaseGameModel {
    /// 该组中对应的房间信息
    @objc var room_list: [[String: NSObject]]? {
        // 属性监听器
        didSet {
            guard let room_list = room_list else {
                return
            }
            for dict in room_list {
                anchors.append(AnchorModal(dict: dict))
            }
        }
    }
    /// 组显示的图标
    @objc var icon_name: String = "home_header_normal"
    /// 定义主播的模型对象数组（将全部转换好的数据（AnchorModal）放到这里）---> setValue(_ value: Any?, forKey key: String)
    @objc lazy var anchors: [AnchorModal] = [AnchorModal]()

}
