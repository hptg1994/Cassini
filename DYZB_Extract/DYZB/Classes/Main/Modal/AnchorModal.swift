//
//  AnchorModal.swift
//  DYZB
//
//  Created by 何品泰高 on 2018/11/17.
//  Copyright © 2018 何品泰高. All rights reserved.
//

import Foundation

/// 这个Modal是将AnchorGroup中对应的房间信息room_list转成另一个Modal
class AnchorModal: NSObject {
    // 房间ID
    @objc var room_id: Int = 0

    // 房间图片对应的URLString
    @objc var vertical_src: String = ""

    // 判断是手机直播还是电脑直播 0:手机直播 1:电脑直播
    @objc var isVertical: Int = 0

    // 房间名称
    @objc var room_name: String = ""

    // 主播昵称
    @objc var nickname: String = ""

    // 在线人数
    @objc var online: Int = 0

    // 主播所在城市
    @objc var anchor_city: String = ""

    init(dict: [String: NSObject]) {
        super.init()
        setValuesForKeys(dict)
    }

    override func setValue(_ value: Any?, forUndefinedKey key: String) {
    }
}
