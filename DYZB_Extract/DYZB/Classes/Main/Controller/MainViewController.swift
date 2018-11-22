//
//  MainViewController.swift
//  DYZB
//
//  Created by 何品泰高 on 2018/11/13.
//  Copyright © 2018 何品泰高. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChildVc(storyName: "Home")
        addChildVc(storyName: "Live")
        addChildVc(storyName: "Follow")
        addChildVc(storyName: "Profile")
    }
    
    private func addChildVc(storyName:String){
        // 1. 通过storyboard获取控制器
        let childVc = UIStoryboard(name: storyName, bundle:nil).instantiateInitialViewController()!
        // 2. 将childVc作为子控制器
        addChild(childVc)
    }
}
