//
//  BaseViewModel.swift
//  DYZB
//
//  Created by 何品泰高 on 2018/11/21.
//  Copyright © 2018 何品泰高. All rights reserved.
//

import UIKit

// 12.2.1 对 AmuseViewModel 和 RecommendViewModel 进行一个抽取
class BaseViewModel {

    lazy var anchorGroups: [AnchorGroup] = [AnchorGroup]()
}

extension BaseViewModel {
    func loadAnchorData(URLString: String, parameters: [String: Any]? = nil, finishedCallback: @escaping () -> ()) {
        NetworkTools.requestData(type: .GET, URLString: URLString) { (result) in
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
        }
    }
}
