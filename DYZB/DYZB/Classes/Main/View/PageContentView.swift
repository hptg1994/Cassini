//
// Created by 何品泰高 on 2018/11/14.
// Copyright (c) 2018 何品泰高. All rights reserved.
//

import UIKit

private let ContentCellId = "ContentCellID"

// 每个TabLabel下的自定义内面内容
class PageContentView: UIView {

    // Mark:- 定义属性
    private var childVcs: [UIViewController]
    private weak var parentViewController: UIViewController?

    //MARK:- 懒加载
    // collectionView 可以滑动，就像Flutter中的CollectionView
    private lazy var collectionView: UICollectionView = { [weak self] in
        // 1.创建Layout
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = (self?.bounds.size)!
        // 行间距为0
        layout.minimumLineSpacing = 0
        // item的间距也是0
        layout.minimumInteritemSpacing = 0
        // 滚动方向
        layout.scrollDirection = .horizontal
        // 2.创建UICollectionView
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        // 需要分页进行显示
        collectionView.isPagingEnabled = true
        // 不要超出内容的滚动区域
        collectionView.bounces = false

        // collectionView中显示内容
        collectionView.dataSource = self

        // 注册这个Cell,后一个参数是它们的标识
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: ContentCellId)

        return collectionView
    }()

    // Mark:- 自定义的构造函数，有一个childVcs数组，有几个页面就放几个页面进这个数组，但这些控制器要用到的话，要传到他们的父控制器里面
    init(frame: CGRect, childVcs: [UIViewController], parentViewController: UIViewController?) {
        self.childVcs = childVcs
        self.parentViewController = parentViewController
        super.init(frame: frame)

        // 设置UI
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK:- 设置UI界面
extension PageContentView {
    private func setupUI() {
        // 1. 将所有的子控制器添加到父控制器
        for childVc in childVcs {
            parentViewController?.addChild(childVc)
        }
        // 2.添加UICollectionView（用于左右进行滚动）,用于在Cell中存放控制器的View
        addSubview(collectionView)
        collectionView.frame = bounds

    }
}

// MARK:- 遵守UICollectionViewDataSource协议, 继承UICollectionViewDataSource，要conform to protocol
extension PageContentView: UICollectionViewDataSource {
    // 要实现两个方法
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 1.创建Cell，从缓冲池中获得这个Cell，但在这之前，要register这个cell --> collectionView.register
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCellId, for: indexPath)

        // 2.给Cell设置内容

        // 2.1 为了Cell可以循环利用，每一次都要重置，为防止cell添加过多的subview
        for view in cell.contentView.subviews {
            // 把contentView中的之前的View移除一下
            view.removeFromSuperview()
        }
        let childVc = childVcs[indexPath.item]
        childVc.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVc.view)
        return cell
    }
}


// MARK:- 对外暴露的方法,因为要让外面设置这里面的方法，要传出去
extension PageContentView {

    // 返回HomeViewController中的Delegate用
    func setCurrentIndex(currentIndex:Int){
        // 怎样子滚过去？计算Offset
        let offsetX = CGFloat(currentIndex) * collectionView.frame.width
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
}
