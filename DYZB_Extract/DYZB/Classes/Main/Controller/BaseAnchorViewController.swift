//
//  BaseAnchorViewController.swift
//  DYZB
//
//  Created by 何品泰高 on 2018/11/21.
//  Copyright © 2018 何品泰高. All rights reserved.
//

import UIKit

let kItemMargin: CGFloat = 10
let kNormalItemWidth = (kScreenWidth - 3 * kItemMargin) / 2
let kNormalItemHeight = kNormalItemWidth * 3 / 4
let kLargerItemHeight = kNormalItemWidth  * 4 / 3
let kHeaderViewHeight: CGFloat = 50
let kHeaderPhotoCycleViewHeight = kScreenWidth * 3 / 8
let kGameViewHeight: CGFloat = 90
let kNormalCellID = "kNormalCellID"
let kLargerCellID = "kLargerCellID"
let kHeaderViewID = "kHeaderViewID"

class BaseAnchorViewController: ViewController {

    // MARK: 定义属性
    var baseVM: BaseViewModel!

    lazy var collectionView: UICollectionView = { [unowned self] in
        // 1.创建布局 => 流水布局
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: kNormalItemWidth, height: kNormalItemHeight)
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

        // 6.5.2 注册Cell --> 6.5.3 添加组头(PS:这个只是演示怎么注册，实际的注册看6.7.2)
        /*collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kNormalCellID)*/
        // 6.5.4 注册组头 --> 6.5.5 和取Cell一样，取头(PS:这个只是演示怎么注册，实际的注册看6.6.1)
        /*collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: kHeaderViewID)*/
        //  6.6.1 注册Section Header xib --> 6.5.5 和取Cell一样，取头
        collectionView.register(UINib(nibName: "CollectionHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: kHeaderViewID)

        // 6.7.2 注册Cell Xib ---> 6.5.1 和取Header一样，取Cell
        collectionView.register(UINib(nibName: "CollectionNormalCell", bundle: nil), forCellWithReuseIdentifier: kNormalCellID)
        collectionView.register(UINib(nibName: "CollectionLargerCell", bundle: nil), forCellWithReuseIdentifier: kLargerCellID)
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData()
    }
}

extension BaseAnchorViewController {
    @objc func setupUI() {
        view.addSubview(collectionView)
    }
}

extension BaseAnchorViewController {
    @objc func loadData() {}
}

extension BaseAnchorViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return baseVM.anchorGroups.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return baseVM.anchorGroups[section].anchors.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 1.取出cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kNormalCellID, for: indexPath) as! CollectionNormalCell

        cell.anchor = baseVM.anchorGroups[indexPath.section].anchors[indexPath.item]

        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kHeaderViewID, for: indexPath) as! CollectionHeaderView
        headerView.group = baseVM.anchorGroups[indexPath.section]
        return headerView

    }
}


