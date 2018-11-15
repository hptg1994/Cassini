//
//  HomeViewController.swift
//  DYZB
//
//  Created by 何品泰高 on 2018/11/13.
//  Copyright © 2018 何品泰高. All rights reserved.
//

import UIKit

private let kTitleViewHeight: CGFloat = 40

class HomeViewController: UIViewController {
    //MARK: 懒加载熟悉(利用闭包的形式马上执行)
    private lazy var pageTitleView: PageTitleView = {
        let titleFrame = CGRect(x: 0, y: kStatusBarHeight + kNavigationBarHeight, width: kScreenWidth, height: kTitleViewHeight)
        let titles = ["推荐", "游戏", "娱乐", "趣玩"]
        let titleView = PageTitleView(frame: titleFrame, titles: titles)
        return titleView
    }()

    private lazy var pageContentView: PageContentView = { [weak self ] in
        // 1.确定内容的frame
        let contentHeight = kScreenHeight - kStatusBarHeight - kNavigationBarHeight - kTitleViewHeight
        let contentFrame = CGRect(x: 0, y: kStatusBarHeight + kNavigationBarHeight + kTitleViewHeight, width: kScreenWidth, height: contentHeight)

        // 2.确定所有的子控制器
        var childVcs = [UIViewController]()
        for _ in 0..<4 {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor(r: CGFloat(arc4random_uniform(255)), g: CGFloat(arc4random_uniform(255)), b: CGFloat(arc4random_uniform(255)))
            childVcs.append(vc)
        }
        let contentView = PageContentView(frame: contentFrame, childVcs: childVcs, parentViewController: self)
        return contentView
    }()

    //MARK:- 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        // 设置UI界面
        setupUI()
    }
}

// MARK: -- 设置UI界面
extension HomeViewController {

    private func setupUI() {
        // 0. 不需要调整UIScrollView的内边距
        automaticallyAdjustsScrollViewInsets = false

        // 1. 设置导航栏
        setupNavigationBar()

        // 2. 添加titleView
        view.addSubview(pageTitleView)

        // 3. 添加ContentView
        view.addSubview(pageContentView)
        pageContentView.backgroundColor = UIColor.purple
    }

    /* 设置导航栏的具体内容 */
    private func setupNavigationBar() {
        // 设置左侧的Item
        /* 下面这个是原始的方法，但是我们设置了UIBarButtonItem的extension，所以我们开始用extension中自定义的constructor
        let btn = UIButton()
        btn.setImage(UIImage(named: "logo"), for: .normal)
        btn.sizeToFit()*/
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "logo")

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
        navigationItem.rightBarButtonItems = [historyItem, searchItem, qrcodeItem]
    }
}

