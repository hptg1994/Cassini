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
private let kNormalItemHeight = kItemWidth * 3 / 4
private let kLargerItemHeight = kItemWidth * 4 / 3
private let kHeaderViewHeight: CGFloat = 50

private let kNormalCellID = "kNormalCellID"
private let kLargerCellID = "kLargerCellID"
private let kHeaderViewID = "kHeaderViewID"

// 6.0 创建推荐页面的Class
class RecommendViewController: UIViewController {

    // MARK:- 属性
    // 6.2 设置全局UICollectionView属性 --> 6.3
    private lazy var collectionView: UICollectionView = { [unowned self] in
        // 1.创建布局 => 流水布局
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: kItemWidth, height: kNormalItemHeight)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = kItemMargin
        // 6.5.3 添加组头,但是要想在这个组头中添加View，就要注册这个头 --> 6.5.4 注册组头
        layout.headerReferenceSize = CGSize(width: kScreenWidth, height: kHeaderViewHeight)
        layout.sectionInset = UIEdgeInsets(top: 0, left: kItemMargin, bottom: 10, right: kItemMargin) //这个东西相当于padding
        // 2.创建UICollectionView,第二个参数是刚刚建的布局
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        // 6.4 添加内容，Controller成为CollectionView的控制元 --> 6.5 遵守UICollectionView的dataSource的协议
        collectionView.dataSource = self
        // 6.8 让self实现UICollectionViewDelegate --> 6.8.1 实现他的sizeForItemAtIndexPath的方法
        collectionView.delegate = self
        // 自适应collectionView宽高,随着父控件的缩小而缩小
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]

        /*// 6.5.2 注册Cell --> 6.5.3 添加组头(PS:这个只是演示怎么注册，实际的注册看6.7.2)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kNormalCellID)*/
        /*// 6.5.4 注册组头 --> 6.5.5 和取Cell一样，取头(PS:这个只是演示怎么注册，实际的注册看6.6.1)
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: kHeaderViewID)*/

        //  6.6.1 注册Section Header xib --> 6.5.5 和取Cell一样，取头
        collectionView.register(UINib(nibName: "CollectionHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: kHeaderViewID)

        // 6.7.2 注册Cell Xib ---> 6.5.1 和取Header一样，取Cell
        collectionView.register(UINib(nibName: "CollectionNormalCell", bundle: nil), forCellWithReuseIdentifier: kNormalCellID)
        collectionView.register(UINib(nibName: "CollectionLargerCell", bundle: nil), forCellWithReuseIdentifier: kLargerCellID)
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
extension RecommendViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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

        // 6.5.1 获取Cell(按Section不同区分不同的Cell),但想要获取Cell，必须先要注册Cell --> 6.5.2 注册Cell
        var cell: UICollectionViewCell
        if indexPath.section == 1 {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: kLargerCellID, for: indexPath)
        } else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: kNormalCellID, for: indexPath)
        }
        return cell //这一步完了，没结束，如果只是这样的话cell的大小是不能随section的不同而改变的，因此还要让这个class实现UICollectionView的Delegate --> 6.8 让self实现UICollectionViewDelegate
    }

    // 6.5.5 和取Cell一样，取头,用这个方法：---> 6.7定义cell的内容
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        // 1.取出sectionHeaderView
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kHeaderViewID, for: indexPath)
        return headerView
    }

    // 6.8.1 实现他的sizeForItemAtIndexPath的方法
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 1 {
            return CGSize(width: kItemWidth, height: kLargerItemHeight)
        }
        return CGSize(width: kItemWidth, height: kNormalItemHeight)
    }
}
