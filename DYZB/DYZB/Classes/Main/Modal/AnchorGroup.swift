//
// Created by 何品泰高 on 2018/11/17.
// Copyright (c) 2018 何品泰高. All rights reserved.
//

import Foundation

class AnchorGroup: NSObject {
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

    /// 组显示的标题
    @objc var tag_name: String = ""

    /// 组显示的图标
    @objc var icon_name: String = "home_header_normal"

    /// 组显示的图标URL
    @objc var icon_url: String = ""

    /// 定义主播的模型对象数组（将全部转换好的数据（AnchorModal）放到这里）---> setValue(_ value: Any?, forKey key: String)
    @objc lazy var anchors: [AnchorModal] = [AnchorModal]()


    // MARK:- 构造函数，这个是原来的
    init(dict: [String: NSObject]) {
        super.init()
        setValuesForKeys(dict)
    }

    // 这个是不带参数的构造函数，但是原来的不是这个，所以要override
    override init() {

    }

    override func setValue(_ value: Any?, forUndefinedKey key: String) {
    }

    // 将转换好的东西append到anchors数组中，但是这样子，有个更好的方法 ---> 属性监听器
    /*override func setValue(_ value: Any?, forKey key: String) {
        if key == "room_list" {
            if let dataArray = value as? [[String: NSObject]] {
                for dict in dataArray {
                    anchors.append(AnchorModal(dict: dict))
                }
            }
        }
    }*/
}
