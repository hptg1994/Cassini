//
//  GameViewModel.swift
//  DYZB
//
//  Created by 何品泰高 on 2018/11/20.
//  Copyright © 2018 何品泰高. All rights reserved.
//

import UIKit

class GameViewModel {
    // 11.4 在GameViewModel中保存这个模型
    lazy var games :[GamePageModel] = [GamePageModel]()
}

extension GameViewModel {
    func loadAllGameData(finishedCallback: @escaping () -> ()){
        NetworkTools.requestData(type: .GET, URLString: "http://capi.douyucdn.cn/api/v1/getColumnDetail") { (result) in
            // 1.获取数据
            guard let resultDict = result as? [String:Any] else {return}
            guard let dataArray = resultDict["data"] as? [[String : Any]] else {return}
            
            // 2.字典转模型
            for dict in dataArray {
                self.games.append(GamePageModel(dict: dict))
            }
            
            // 3.完成回调
            finishedCallback()
         }
    }
}
