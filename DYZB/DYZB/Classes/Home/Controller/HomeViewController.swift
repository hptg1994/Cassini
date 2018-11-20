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
    
    //3.2 初始化PageTilteView,懒加载(利用闭包的形式马上执行) ---> 3.3 设置titleView:addSubview()
    private lazy var pageTitleView: PageTitleView = { [weak self] in
        let titleFrame = CGRect(x: 0, y: kStatusBarHeight + kNavigationBarHeight, width: kScreenWidth, height: kTitleViewHeight)
        let titles = ["推荐", "游戏", "娱乐", "趣玩"]
        let titleView = PageTitleView(frame: titleFrame, titles: titles)

        // 5.3 成为PageTitleViewDelegate的代理 ---> 5.4 然后必须遵守协议
        titleView.delegate = self
        return titleView
    }()

    // 4.2 初始化PageContentView,懒加载(利用闭包的形式马上执行) ---> 4.3 设置PageContentView:addSubView()
    private lazy var pageContentView: PageContentView = { [weak self ] in
        // 1.确定内容的frame
        let contentHeight = kScreenHeight - kStatusBarHeight - kNavigationBarHeight - kTitleViewHeight - kTabbarHeight
        let contentFrame = CGRect(x: 0, y: kStatusBarHeight + kNavigationBarHeight + kTitleViewHeight, width: kScreenWidth, height: contentHeight)
        // 2.确定所有的子控制器
        var childVcs = [UIViewController]()
        childVcs.append(RecommendViewController())
        // 11.1 添加GameViewController到childVcs中 ---> 11.2 对i进行数据展示的UICollectionView进行懒加载
        childVcs.append(GameViewController())
        for _ in 0..<2 {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor(r: CGFloat(arc4random_uniform(255)), g: CGFloat(arc4random_uniform(255)), b: CGFloat(arc4random_uniform(255)))
            childVcs.append(vc)
        }
        let contentView = PageContentView(frame: contentFrame, childVcs: childVcs, parentViewController: self)
        // 5.7.3让首页成为代理 --> 5.7.4 遵守PageContentViewDelegate的协议
        contentView.delegate = self
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

        // 2. 设置导航栏
        setupNavigationBar()

        // 3.3 添加titleView --> 4.（思想）和 4.1 建立PageContentView的class 和 4.3 添加ContentView
        view.addSubview(pageTitleView)

        // 4.3 添加ContentView ---> 4.1.2 设置UI界面
        view.addSubview(pageContentView)
        pageContentView.backgroundColor = UIColor.purple
    }

    /* 设置导航栏的具体内容 */
    private func setupNavigationBar() {
        // 2.1 设置左侧的Item --> Tools/UIBarButtonItem-Extension定义了UIBarButtonItem的Extension
        /* 下面这个是原始的方法，但是我们设置了UIBarButtonItem的extension，所以我们开始用extension中自定义的constructor
        let btn = UIButton()
        btn.setImage(UIImage(named: "logo"), for: .normal)
        btn.sizeToFit()*/
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "logo")

        // 2.2设置右侧的Item
        // 2.2.1 初始化三个Button
        let size = CGSize(width: 40, height: 40)
        /*Swift 建议使用构造函数（不行的话就用createItem方法),看下面的具体方法
        let historyItem = UIBarButtonItem.createItem(imageName: "image_my_history", highLightImageName: "Image_my_history_click", size: size)
        let searchItem = UIBarButtonItem.createItem(imageName: "btn_search", highLightImageName: "btn_search_clicked", size: size)
        let qrcodeItem = UIBarButtonItem.createItem(imageName: "Image_scan", highLightImageName: "Image_scan_click", size: size)*/
        let historyItem = UIBarButtonItem(imageName: "image_my_history", highLightImageName: "Image_my_history_click", size: size)
        let searchItem = UIBarButtonItem(imageName: "btn_search", highLightImageName: "btn_search_clicked", size: size)
        let qrcodeItem = UIBarButtonItem(imageName: "Image_scan", highLightImageName: "Image_scan_click", size: size)
        // 2.2.2 将这3个button放入rightBarButtonItems
        navigationItem.rightBarButtonItems = [historyItem, searchItem, qrcodeItem]
    }
}

//5.4 MARK:- 遵守PageTitleViewDelegate协议
extension HomeViewController: PageTitleViewDelegate {
    func pageTitleView(_ titleView: PageTitleView, selectedIndex index: Int) {
         //然后此时点击TitleLabel后就可以显示它们的index --> 5.5 index传入PageContentView,使用PageContentView中暴露的方法把index传进来
        pageContentView.setCurrentIndex(currentIndex: index)

    }
}

//5.7.4 遵守PageContentViewDelegate的协议
extension HomeViewController:PageContentViewDelegate {
    func pageContentView(contentView: PageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        // 5.7.5 将这些数据传递给titleView ---> 5.7.6 对传进来的参数做一些设置
        pageTitleView.setTitleWithProgress(progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}

