//
//  RecommendCycleView.swift
//  DYZB
//
//  Created by 何品泰高 on 2018/11/18.
//  Copyright © 2018 何品泰高. All rights reserved.
//

import UIKit


private let kCycleCellID = "kCycleCellID"

// 9.无线轮播 布局界面 --> 9.1 添加子控件xib(手动) --> 9.2 提供一个快速创建View的类方法
class RecommendCycleView: UIView {

    var cycleTimer: Timer?

    // 9.15.3(7) RecommendCycleView中使用这个数据 ---> 9.15.3(8) Pre展示这个View
    var cycleModels: [PageHeaderCycleModel]? {
        // 9.15.3(8) Pre展示这个View (reloadData会重新调用遵守的协议)
        didSet {
            // 1.刷新collectionView
            collectionView.reloadData()
            // 2.设置PageControl的个数 ----> 9.16 将实际的Json数据展示到页面上
            pageControl.numberOfPages = cycleModels?.count ?? 0

            // 3.默认滚动到中间某一个位置(现在不是有10000多个嘛，从一开始先默认让他滚动到60的这个位置，这样子往前滚就是显示第59个) --> 9.21.2 实现自动滚动（定时器）
            let indexPath = IndexPath(item: (cycleModels?.count ?? 0)*10, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
            
            // 9.21.3 添加定时器 ---> 9.21.4 当在滚动时用户拖动，应该停止自动滚动(e.g:监听用户进行的滚动)
            removeCycleTimer()
            addCycleTimer()
        }
    }

    //MARK:- 控件属性 9.10拖拽完collectionView后要做一件事情，注册这个cell --> 9.11注册这个cell
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!

    // 9.5 取消这个View随父控件的缩放而缩放
    override func awakeFromNib() {
        super.awakeFromNib()
        // 设置该控件不随着父控件的拉伸而拉伸(课时23无限轮播中有解释) ---> 9.6 设置collectionView的内边距使其能够显示在collectionView的顶部（给他一个在collectionView显示的空间）
        autoresizingMask = []

        // 9.11 注册这个cell --> 9.12 启动这个Cell(dequeueReusableCell) --> 9.13 通过layoutSubviews中拿到实际的计算出来的尺寸（而不是xib中的尺寸）
        /// PS 在9.17自定义完这个Cell后，就要实际上注册这个新Cell了,，不再是注册UICollectionViewCell.self
        // collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kCycleCellID)
        collectionView.register(UINib(nibName: "CollectionHeaderPageCycleCell", bundle: nil), forCellWithReuseIdentifier: kCycleCellID)

    }

    // 9.13 通过layoutSubviews中拿到实际的计算出来的尺寸（而不是xib中的尺寸）--> 9.14
    override func layoutSubviews() {
        super.layoutSubviews()
        // 9.14 设置collectionView的一个布局使cell可以铺满每一个页面(collectionViewLayout只是一个普通的Layout，要强转成UICollectionViewFlowLayout,这样才能拿到里面的itemn并设置size) ---> 9.15 请求并展示数据
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = collectionView.bounds.size //这样每个cell就可以单独占据一个页面

        // 以下这些可以直接在xib的属性中设置
        /* layout.minimumLineSpacing = 0 //layout 和 layout之间的一个间距
        layout.minimumInteritemSpacing = 0 // layout item 和 layout item之间的间距
        layout.scrollDirection = .horizontal
        collectionView.isPagingEnabled = true */
    }
}

extension RecommendCycleView {
    // 9.2 提供一个快速创建View的类方法 --> 9.3 回到RecommendViewController 中，创建View，懒加载
    class func recommendCycleView() -> RecommendCycleView { // 这里为什么要class有待查阅
        return Bundle.main.loadNibNamed("RecommendCycleView", owner: nil, options: nil)?.first as! RecommendCycleView
    }
}

// 在9.8:显示数据（必须设置数据源（右键xib，将datasouce拖拽至RecommandCycleViewController（左侧面板））之后 ---> 9.9 遵守UICollectionView的一个数据源协议
extension RecommendCycleView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // return 6
        return (cycleModels?.count ?? 0) * 10000
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 9.12 启动这个Cell(dequeueReusableCell) --> 9.13 设置collectionView的一个布局使cell可以铺满y每一个页面
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCycleCellID, for: indexPath) as! CollectionHeaderPageCycleCell
        // 9.16 将实际的Json数据展示到页面上 ---> 9.17 自定义cell来进行展示（新建UICollectionViewCell） ---> 注册这个新的Cell --> 将上面的cell强制转换成CollectionHeaderPageCycleCell ---> 9.18 将模型传给这个新的Cell
        // let cycleModel = cycleModels![indexPath.item]
        cell.cycleModel = cycleModels![indexPath.item % cycleModels!.count]
        return cell
    }
}

// 9.20 监听图片的滚动并跟着改变右下角的点位置
// 遵守UICollectionView的代理协议
extension RecommendCycleView: UICollectionViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 1. 获取滚动的一个偏移量
        let offsetX = scrollView.contentOffset.x + scrollView.bounds.width * 0.5
        // 2. 计算出pageControl应该到达的Index ---> 3.设置在page滚动一半后index跳到下一个(+ scrollView.bounds.width * 0.5) ---> 9.21 实现无限轮播&自动滚动
        pageControl.currentPage = Int(offsetX / scrollView.bounds.width) % (cycleModels?.count ?? 1)
     }
    
    // 9.21.4 当在滚动时用户拖动，应该停止自动滚动(e.g:监听用户进行的拖拽,两个方法，scrollViewWillBeginDragging和scrollViewWillEndDragging，当用户开始拖拽的时候call scrollViewWillBeginDragging，当用户结束拖拽call scrollViewWillEndDragging，将定时器加回来)
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        removeCycleTimer()
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        addCycleTimer()
    }
}


// 9.21.2 实现自动滚动（定时器） ---> 9.21.3 添加定时器
extension RecommendCycleView {
    private func addCycleTimer() {
        cycleTimer = Timer(timeInterval: 3.0, target: self, selector: #selector(scrollToNext), userInfo: nil, repeats: true)
        // 这个定时器应该加到运行情况以及Common模式下
        RunLoop.main.add(cycleTimer!,forMode:RunLoop.Mode.common)
    }
    
    private func removeCycleTimer(){
        cycleTimer?.invalidate() // 从运行循环中移除
        cycleTimer = nil
    }
    
    @objc private func scrollToNext(){
        // 获取要滚动的一个偏移量
        let currentOffsetX = collectionView.contentOffset.x
        let offsetX = currentOffsetX + collectionView.bounds.width
        
        // 滚动该位置
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
        
    }
}
