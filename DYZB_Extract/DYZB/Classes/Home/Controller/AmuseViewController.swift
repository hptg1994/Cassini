//
//  AmuseViewController.swift
//  DYZB
//
//  Created by 何品泰高 on 2018/11/21.
//  Copyright © 2018 何品泰高. All rights reserved.
//

import UIKit

private let kMenuViewHeight: CGFloat = 200

class AmuseViewController: BaseAnchorViewController {

    // 新建数据请求AmuseViewModel的实例对象
    fileprivate lazy var amuseVM: AmuseViewModel = AmuseViewModel()

    // 12.4.3 在对应的控制器中添加懒加载 --> 12.4.4 加载进collectionView中
    fileprivate lazy var menuView:AmuseMenuView = {
        let menuView = AmuseMenuView.amuseMenuView()
        menuView.frame = CGRect(x: 0, y: -kMenuViewHeight, width: kScreenWidth, height: kMenuViewHeight)
        return menuView
    }()

}


extension AmuseViewController {

    // 12.4.4 加载进collectionView中(要重写父方法)
    override func setupUI() {
        super.setupUI()
        collectionView.addSubview(menuView)
        // 设置内边距，给AmuseMenuView留一个位置
        collectionView.contentInset = UIEdgeInsets(top: kMenuViewHeight, left: 0, bottom: 0, right: 0)
    }
}

extension AmuseViewController {
    override func loadData() {
        // 给父类中的ViewModel进行赋值
        baseVM = amuseVM
        amuseVM.loadAmuseData {
            self.collectionView.reloadData()
        }
    }
}

