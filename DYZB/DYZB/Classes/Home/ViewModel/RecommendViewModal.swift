//
// Created by 何品泰高 on 2018/11/17.
// Copyright (c) 2018 何品泰高. All rights reserved.
//

import Foundation

class RecommendViewModal {
    // MARK:- 7.6 创建出来的每一个group将它放到全局对象中
    lazy var anchorGroups: [AnchorGroup] = [AnchorGroup]()
    // 9.15.3(5) 创建对应的懒加载属性,创建的每一个pageHeaderCycleModels将它放到全局对象中 ---> 9.15.3(6) RecommendViewController中使用这个数据/**/
    lazy var pageHeaderCycleModels = [PageHeaderCycleModel]()
    private lazy var bigDataGroup: AnchorGroup = AnchorGroup()
    private lazy var prettyDataGroup: AnchorGroup = AnchorGroup()
}

// 7.3 建立这个RecommendViewModal这个Class并完善requestData这个function
extension RecommendViewModal {
    // 请求推荐数据
    func requestData(finishCallback: @escaping () -> ()) {
        // 0.定义参数
        let parameters = ["limit": "4", "offset": "0", "time": NSDate.getCurrentTime() as NSString]

        // 0.1 创建Group进行Async Function 以保证第一组的数据永远是在开头
        let disGroup = DispatchGroup()

        // 1.请求第一部分推荐数据
        disGroup.enter()
        NetworkTools.requestData(type: .GET, URLString: "http://capi.douyucdn.cn/api/v1/getbigDataRoom", parameters: ["time": NSDate.getCurrentTime() as NSString]) { result in

            // 1.将result转成字典类型
            guard let resultDict = result as? [String: NSObject] else {
                return
            }
            // 2.根据data和key，获取数组
            guard let dataArray = resultDict["data"] as? [[String: NSObject]] else {
                return
            }

            // 3. 遍历字典，并且转成模型对象
            // 3.1 设置组的属性
            self.bigDataGroup.tag_name = "热门"
            self.bigDataGroup.icon_name = "home_header_hot"
            // 3.2 获取主播数据
            for dict in dataArray {
                let anchor = AnchorModal(dict: dict)
                self.bigDataGroup.anchors.append(anchor)
            }
            // 3.4 离开组
            disGroup.leave()
            print("请求到0")
        }
        // 2.请求第二部份颜值数据
        disGroup.enter()
        NetworkTools.requestData(type: .GET, URLString: "http://capi.douyucdn.cn/api/v1/getVerticalRoom", parameters: parameters) { result in
            // 1.将result转成字典类型
            guard let resultDict = result as? [String: NSObject] else {
                return
            }
            // 2.根据data和key，获取数组
            guard let dataArray = resultDict["data"] as? [[String: NSObject]] else {
                return
            }
            // 3. 遍历字典，并且转成模型对象
            // 3.1 设置组的属性
            self.prettyDataGroup.tag_name = "颜值"
            self.prettyDataGroup.icon_name = "home_header_phone"
            // 3.2 获取主播数据
            for dict in dataArray {
                let anchor = AnchorModal(dict: dict)
                self.prettyDataGroup.anchors.append(anchor)
            }

            // 3.3 离开组
            disGroup.leave()
            print("请求到1")
        }

        // 3.请求后面部分游戏数据
        disGroup.enter()
        NetworkTools.requestData(type: .GET, URLString: "http://capi.douyucdn.cn/api/v1/getHotCate?limit=4&offset=0", parameters: parameters) { result in
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

            // 3.4 离开组
            disGroup.leave()
            print("请求到2-12数据")
        }

        // 所有的数据都请求到，进行排序
        disGroup.notify(queue: DispatchQueue.main) {
            self.anchorGroups.insert(self.prettyDataGroup, at: 0)
            self.anchorGroups.insert(self.bigDataGroup, at: 0)
            finishCallback()
        }
    }

    // 9.15.1请求无限轮播的数据 ---> 9.15.2 RecommandViewController中的loadData调用这个方法
    func requestCycleData(finishCallback: @escaping () -> ()) {
        NetworkTools.requestData(type: .GET, URLString: "http://www.douyutv.com/api/v1/slide/6", parameters: ["version": "2.300"]) { result in
            // 9.15.3 解析数据
            // 9.15.3(1) 获取字典数据
            guard let resultDict = result as? [String: NSObject] else {
                return
            }
            // 9.15.3(2) 根据data的key获取数据
            guard let dataArray = resultDict["data"] as? [[String: NSObject]] else { return }
            // 9.15.3(3) 字典转模型 ---> 9.15.3(4) 创建对应的Model
            for dict in dataArray {
                self.pageHeaderCycleModels.append(PageHeaderCycleModel(dict: dict))
            }


            finishCallback()
        }
    }

}
