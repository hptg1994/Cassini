//
//  RecommendViewController.swift
//  DYZB
//
//  Created by 何品泰高 on 2018/11/16.
//  Copyright © 2018 何品泰高. All rights reserved.
//

import UIKit

private let kItemMargin: CGFloat = 10
private let kItemWidth = (kScreenWidth - 3 * kItemMargin) / 2
private let kItemHeight = kItemWidth * 3 / 4
private let kHeaderViewHeight: CGFloat = 50

private let kNormalCellID = "kNormalCellID"
private let kHeaderViewID = "kHeaderViewID"

// 6.0 创建推荐页面的Class
class RecommendViewController: UIViewController {

    // MARK:- 属性
    // 6.2 设置全局UICollectionView属性 --> 6.3
    private lazy var collectionView: UICollectionView = { [unowned self] in
        // 1.创建布局 => 流水布局
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: kItemWidth, height: kItemHeight)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = kItemMargin
        // 6.5.3 添加组头,但是要想在这个组头中添加View，就要注册这个头 --> 6.5.4 注册组头
        layout.headerReferenceSize = CGSize(width: kScreenWidth, height: kHeaderViewHeight)
        layout.sectionInset = UIEdgeInsets(top: 0, left: kItemMargin, bottom: 10, right: kItemMargin) //这个东西相当于padding
        // 2.创建UICollectionView,第二个参数是刚刚建的布局
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.blue
        // 6.4 添加内容，Controller成为CollectionView的控制元 --> 6.5 遵守UICollectionView的dataSource的协议
        collectionView.dataSource = self
        // 自适应collectionView宽高,随着父控件的缩小而缩小
        collectionView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        // 6.5.2 注册Cell --> 6.5.3 添加组头
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kNormalCellID)
        // 6.5.4 注册组头 --> 6.5.5 和取Cell一样，取头
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: kHeaderViewID)
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.purple
        // 6.1设置UI
        setupUI()
    }

}


// 6.1 MARK:- 设置UI界面的内容 --> 6.2 设置全局UICollectionView属性
extension RecommendViewController {
    private func setupUI() {
        // 6.3 将UICollectionView添加到控制器的View中 --> 6.4 添加内容，Controller成为CollectionView的控制元
        view.addSubview(collectionView)
    }
}

// 6.5 遵守UICollectionView的dataSource的协议（必实现numberOfItemsInSection和cellForItemAt）
extension RecommendViewController: UICollectionViewDataSource {
    // 6.5.1 将要实现的UI中有12组分组，实现这个方法
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 12
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 8
        }
        return 4
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 1.获取Cell,但想要获取Cell，必须先要注册Cell --> 6.5.2 注册Cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kNormalCellID, for: indexPath)
        cell.backgroundColor = UIColor.red
        return cell
    }

    // 6.5.5 和取Cell一样，取头,用这个方法：
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        // 1.取出sectionHeaderView
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kHeaderViewID, for: indexPath)
        headerView.backgroundColor = UIColor.green
        return headerView
    }
}
