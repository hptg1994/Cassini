//
// Created by 何品泰高 on 2018/11/17.
// Copyright (c) 2018 何品泰高. All rights reserved.
//

import Foundation

class RecommendViewModal {
    // MARK:- 7.6 创建出来的每一个group将它放到全局对象中
    private lazy var anchorGroups: [AnchorGroup] = [AnchorGroup]()
}

// 7.3 建立这个RecommendViewModal这个Class并完善requestData这个function
extension RecommendViewModal {
    func requestData() {
        // 1.请求第一部分推荐数据

        // 2.请求第二部份颜值数据

        // 3.请求后面部分游戏数据
        NetworkTools.requestData(type: .GET, URLString: "http://capi.douyucdn.cn/api/v1/getHotCate?limit=4&offset=0", parameters: ["limit": "4", "offset": "0", "time": NSDate.getCurrentTime() as NSString]) { result in
            // 1.将result转成字典类型
            guard let resultDict = result as? [String: NSObject] else {
                return
            }

            // 2.根据data和key，获取数组
            guard let dataArray = resultDict["data"] as? [[String: NSObject]] else {
                return
            }

            // 3.遍历数组，获取字典，并且将字典转成模型对象 ---> 7.4 建立主播模型
            for dict in dataArray {
                // 7.5 字典转模型 ---> 7.6 创建出来的每一个group将它放到全局对象中
                let group = AnchorGroup(dict: dict)
                self.anchorGroups.append(group)
            }

            for group in self.anchorGroups {
                for anchor in group.anchors {
                    print(anchor.nickname)
                }
            }
        }
    }
}
