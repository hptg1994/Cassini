//
//  HomeViewController.swift
//  DYZB
//
//  Created by 何品泰高 on 2018/11/13.
//  Copyright © 2018 何品泰高. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置UI界面
        setupUI()
    }
}

// MARK: -- 设置UI界面
extension HomeViewController {
    
    private func setupUI(){
        // 1. 设置导航栏
        setupNavigationBar()
    }
    
    private func setupNavigationBar(){
        
        // 设置左侧的Item
        let btn = UIButton()
        btn.setImage(UIImage(named: "logo"), for: .normal)
        btn.sizeToFit()
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btn)
        
        // 设置右侧的Item
        
        // 1. 设置History Button
        let size = CGSize(width: 40, height: 40)

        /*Swift 建议使用构造函数（不行的话就用createItem方法),看下面的具体方法
        let historyItem = UIBarButtonItem.createItem(imageName: "image_my_history", highLightImageName: "Image_my_history_click", size: size)
        let searchItem = UIBarButtonItem.createItem(imageName: "btn_search", highLightImageName: "btn_search_clicked", size: size)
        let qrcodeItem = UIBarButtonItem.createItem(imageName: "Image_scan", highLightImageName: "Image_scan_click", size: size)*/

        let historyItem = UIBarButtonItem(imageName: "image_my_history", highLightImageName: "Image_my_history_click", size: size)
        let searchItem = UIBarButtonItem(imageName: "btn_search", highLightImageName: "btn_search_clicked", size: size)
        let qrcodeItem = UIBarButtonItem(imageName: "Image_scan", highLightImageName: "Image_scan_click", size: size)

        navigationItem.rightBarButtonItems = [historyItem, searchItem, qrcodeItem ]
        
    }
}
