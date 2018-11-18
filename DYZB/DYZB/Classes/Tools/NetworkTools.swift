//
//  NetworkTools.swift
//  DYZB
//
//  Created by 何品泰高 on 2018/11/17.
//  Copyright © 2018 何品泰高. All rights reserved.
//

import UIKit
import Alamofire

enum MethodType {
    case GET
    case POST
}

class NetworkTools {
    class func requestData(type: MethodType, URLString: String, parameters: [String: NSString]? = nil, finishedCallback: @escaping (_ result: Any) -> ()) {
        // 1.获取类型
        var method:HTTPMethod
        if type == .GET {
            method = HTTPMethod.get
        }else{
            method = HTTPMethod.post
        }
        
        // 2.发送网络请求
        Alamofire.request(URLString, method:method,parameters: parameters).responseJSON { response in
            // 3.获取结果
            guard let result = response.result.value else {
                print(response.result.error)
                return
            }

            // 4.将结果调出去
            finishedCallback(result)
         }


    }
}
