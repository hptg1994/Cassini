//
// Created by 何品泰高 on 2018/11/14.
// Copyright (c) 2018 何品泰高. All rights reserved.
//

import UIKit

//5.7 设置代理 --> 5.7.1 定义代理的属性
protocol PageContentViewDelegate: class {
    func pageContentView(contentView: PageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int)
}

private let ContentCellId = "ContentCellID"

// 4.1 建立PageContentView的class,每个TabLabel下的自定义内面内容 --> 4.1.1 自定义的构造函数
class PageContentView: UIView {

    // Mark:- 定义属性
    private var childVcs: [UIViewController]
    private weak var parentViewController: UIViewController?
    private var startOffsetX: CGFloat = 0
    // 5.7.1 定义代理的属性 --> 5.7.2 通知代理
    weak var delegate: PageContentViewDelegate?
    // 5.8 当点击label的时候并不希望执行scrollDelegate
    private var isForbidScrollDelegate: Bool = false


    //4.1.3 全局设置collectionView
    // collectionView 可以滑动，就像Flutter中的CollectionView
    private lazy var collectionView: UICollectionView = { [weak self] in
        // 1.创建Layout（流水布局） --> 设置以下布局属性
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
        // **collectionView中显示内容** --> 4.1.4 设置数据源extension
        collectionView.dataSource = self
        // 4.1.3(3) 注册这个Cell,后一个参数是它们的标识 --> 4.1.4(2) 给Cell设置内容
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: ContentCellId)

        // 5.6.1 监听collectionView的滚动，设置代理 ---> 5.6.2 遵守UICollectionViewDelegate
        collectionView.delegate = self

        return collectionView
    }()

    //4.1.1 自定义的构造函数，有一个childVcs数组，有几个页面就放几个页面进这个数组，但这些控制器要用到的话，要传到他们的父控制器里面 --> 4.2 初始化PageContentView
    init(frame: CGRect, childVcs: [UIViewController], parentViewController: UIViewController?) {
        self.childVcs = childVcs
        self.parentViewController = parentViewController
        super.init(frame: frame)

        // 4.1.2 设置UI
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//4.1.2 设置UI界面
extension PageContentView {
    private func setupUI() {
        //4.1.2(1) 将所有的子控制器添加到父控制器，这一步没有看懂
        for childVc in childVcs {
            parentViewController?.addChild(childVc)
        }
        //4.1.2(2).添加UICollectionView（用于左右进行滚动）,用于在Cell中存放控制器的View -->4.1.3全局设置collectionView
        addSubview(collectionView)
        collectionView.frame = bounds //这一步设置完后 ---> 添加数据源，collectionView中显示内容
    }
}

// 4.1.4 设置数据源extension-遵守UICollectionViewDataSource协议, 继承UICollectionViewDataSource，要conform to protocol --> 5.0给Label添加手势
extension PageContentView: UICollectionViewDataSource {
    // 要实现两个方法 numberOfItemsInSection & cellForItemAt
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 1.创建Cell，从缓冲池中获得这个Cell，但在这之前，要register这个cell --> 4.1.3(3)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCellId, for: indexPath)
        // 4.1.4(2) 给Cell设置内容
        // 4.1.4(2.1) 为了Cell可以循环利用，每一次都要重置，为防止cell添加过多的subview
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

// 5.6.2 要成为我的代理，必须遵守UICollectionViewDelegate的协议
extension PageContentView: UICollectionViewDelegate {
    //5.6.2(1) 判断是左滑还是右滑，根据拽的那一刻的offset是正还是负
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // 5.8.1 只有在拖动的时候才是false --> 5.8.2 判断是否是点击事件
        isForbidScrollDelegate = false
        // 全局保存这个变量，因为5.6.1(2)中要使用到
        startOffsetX = scrollView.contentOffset.x;
    }

    //5.6.2(2)
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 5.8.2 判断是否是点击事件
        if (isForbidScrollDelegate) {
            return
        }

        // 1.获取需要的数据（1.滚动的进度progress,2.sourceIndex,3.targetIndex）
        var progress: CGFloat = 0
        var sourceIndex: Int = 0
        var targetIndex: Int = 0

        // 2.判断是左滑还是右滑
        let currentOffsetX = scrollView.contentOffset.x
        let scrollViewWidth = scrollView.bounds.width
        if currentOffsetX > startOffsetX {
            //2.1 左滑，计算progress = （offsetX / width:一个PageContentView的宽度）-（之前的width宽度的总数）
            progress = currentOffsetX / scrollViewWidth - floor(currentOffsetX / scrollViewWidth)
            //2.2 计算sourceIndex
            sourceIndex = Int(currentOffsetX / scrollViewWidth)

            //2.3 计算targetIndex
            targetIndex = sourceIndex + 1
            if (targetIndex >= childVcs.count) {
                targetIndex = childVcs.count - 1
            }

            // 2.4 如果完全滑过去 progress,应该变成1
            if (currentOffsetX - startOffsetX == scrollViewWidth) {
                progress = 1
                targetIndex = sourceIndex
            }

        } else {
            //右滑
            progress = 1 - (currentOffsetX / scrollViewWidth - floor(currentOffsetX / scrollViewWidth))
            //2.3 计算targetIndex
            targetIndex = Int(currentOffsetX / scrollViewWidth)
            //2.2 计算sourceIndex
            sourceIndex = targetIndex + 1
            if (sourceIndex >= childVcs.count) {
                sourceIndex = childVcs.count - 1
            }
        }

        // 3.将progress/sourceIndex/targetIndex传递给titleView,使用代理 ---> 5.7
        // 5.7.2 通知代理,把参数传进去，等待成为代理的使用这些参数 ---> 5.7.3让首页成为代理
        delegate?.pageContentView(contentView: self, progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)

    }
}

// 5.5 index传入PageContentView,对外暴露的方法,因为要让外面设置这里面的方法，要传出去 ---> 5.6 TitleView的scrollLine随PageContentView的滚动而滚动 --> 5.6.1 监听collectionView的滚动,即成为他的代理
extension PageContentView {
    // 返回HomeViewController中的Delegate用
    func setCurrentIndex(currentIndex: Int) {

        // 5.8.1 只有在拖动的时候才是false
        isForbidScrollDelegate = true

        // 怎样子滚过去？计算Offset
        let offsetX = CGFloat(currentIndex) * collectionView.frame.width
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
    }
}


