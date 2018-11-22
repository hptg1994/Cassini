//
//  AmuseViewModel.swift
//  DYZB
//
//  Created by 何品泰高 on 2018/11/21.
//  Copyright © 2018 何品泰高. All rights reserved.
//

import Foundation

class AmuseViewModel: BaseViewModel {
    /*lazy var anchorGroups: [AnchorGroup] = [AnchorGroup]()*/
}

extension AmuseViewModel {
    func loadAmuseData(finishedCallback: @escaping() -> ()) {
        loadAnchorData(URLString: "http://capi.douyucdn.cn/api/v1/getHotRoom/2", finishedCallback: finishedCallback)
        /*   NetworkTools.requestData(type: .GET, URLString: "http://capi.douyucdn.cn/api/v1/getHotRoom/2") { (result) in
               // 1.对结果进行处理
               guard let resultDict = result as? [String: Any] else {
                   return
               }
               guard let dataArray = resultDict["data"] as? [[String: Any]] else {
                   return
               }

               // 2.遍历数组中的字典
               for dict in dataArray {
                   self.anchorGroups.append(AnchorGroup(dict: dict))
                }

               // 3.完成回调
               finishedCallback()
           }*/
    }
}
