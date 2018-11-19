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

    // 9.15.3(7) RecommendCycleView中使用这个数据 ---> 9.15.3(8) Pre展示这个View
    var cycleModels:[PageHeaderCycleModel]? {
        // 9.15.3(8) Pre展示这个View (reloadData会重新调用遵守的协议)
        didSet {
            // 1.刷新collectionView
            collectionView.reloadData()
            // 2.设置PageControl的个数 ----> 9.16 将实际的Json数据展示到页面上
            pageControl.numberOfPages = cycleModels?.count ?? 0
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
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kCycleCellID)
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


// 在9.8 显示数据（必须设置数据源（右键xib，将datasouce拖拽至RecommandCycleViewController（左侧面板））之后 ---> 9.9 遵守UICollectionView的一个数据源协议
extension RecommendCycleView:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // return 6
        return cycleModels?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 9.12 启动这个Cell(dequeueReusableCell) --> 9.13 设置collectionView的一个布局使cell可以铺满y每一个页面
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCycleCellID, for: indexPath)
        // 9.16 将实际的Json数据展示到页面上 ---> 9.17 自定义cell来进行展示（新建UICollectionViewCell）
        let cycleModel = cycleModels![indexPath.item]
        return cell
    }
    
}
