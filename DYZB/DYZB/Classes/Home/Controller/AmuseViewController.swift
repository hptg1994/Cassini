//
//  AmuseViewController.swift
//  DYZB
//
//  Created by 何品泰高 on 2018/11/21.
//  Copyright © 2018 何品泰高. All rights reserved.
//

import UIKit

private let kItemMargin: CGFloat = 10
private let kItemWidth = (kScreenWidth - 3 * kItemMargin) / 2
private let kNormalItemHeight = kItemWidth * 3 / 4
private let kLargerItemHeight = kItemWidth * 4 / 3
private let kHeaderViewHeight: CGFloat = 50
private let kHeaderPhotoCycleViewHeight = kScreenWidth * 3 / 8
private let kGameViewHeight: CGFloat = 90
private let kNormalCellID = "kNormalCellID"
private let kLargerCellID = "kLargerCellID"
private let kHeaderViewID = "kHeaderViewID"

class AmuseViewController: UIViewController {

    // 新建数据请求AmuseViewModel的实例对象
    fileprivate lazy var amuseVM: AmuseViewModel = AmuseViewModel()

    // 12.1.2 参见6.2 进行数据展示的UICollectionView进行懒加载(所有的都复制粘贴)(包括自定义的常量，遵循的协议)
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
        setupUI()
        loadData()
    }
}

extension AmuseViewController {
    fileprivate func setupUI() {
        view.addSubview(collectionView)
    }
}

extension AmuseViewController {
    fileprivate func loadData() {
        amuseVM.loadAmuseData {
            self.collectionView.reloadData()
        }
    }
}

extension AmuseViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {


    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return amuseVM.anchorGroups.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return amuseVM.anchorGroups[section].anchors.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 1.取出cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kNormalCellID, for: indexPath) as! CollectionNormalCell


        cell.anchor = amuseVM.anchorGroups[indexPath.section].anchors[indexPath.item]

        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kHeaderViewID, for: indexPath) as! CollectionHeaderView
        headerView.group = amuseVM.anchorGroups[indexPath.section]
        return headerView

    }
}
