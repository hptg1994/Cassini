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
private let kHeaderPhotoCycleViewHeight = kScreenWidth * 3 / 8
private let kGameViewHeight:CGFloat = 90
private let kNormalCellID = "kNormalCellID"
private let kLargerCellID = "kLargerCellID"
private let kHeaderViewID = "kHeaderViewID"

// 6.0 创建推荐页面的Class
class RecommendViewController: UIViewController {

    // MARK:- 属性
    // 7.0 发送网络请求,建立extension,设置网络请求的懒加载 ---> 7.3建立这个RecommendViewModal这个Class并完善requestData这个function
    private lazy var recommendVM: RecommendViewModal = RecommendViewModal()

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

    // 9.3 创建RecommendCycleView，懒加载
    private lazy var headerPhotoCycleView: RecommendCycleView = {
        let cycleView = RecommendCycleView.recommendCycleView() // ---> 任何一个View都要有frame才能显示出来
        cycleView.frame = CGRect(x: 0, y: -(kHeaderPhotoCycleViewHeight+kGameViewHeight), width: kScreenWidth, height: kHeaderPhotoCycleViewHeight) // 这个cycleView应该加到CollectionView里面这样才能随着collectionView的滚动而一起滚动 ---> 9.4 将PageHeaderCycleView添加到CollectionView中
        // 上面一步完成后 ---> 9.5 取消这个View随父控件的缩放而缩放
        return cycleView
    }()

    // 10.2.1 创建RecommendGameView的懒加载属性 --> 10.2.2 将gameView添加到collectionView中
    private lazy var gameView: RecommendGameView = {
        let gameView = RecommendGameView.recommendGameView()
        //  10.2.3 设置这个gameView的frame使其位置固定 ---> 10.2.4 取消自动缩放
        gameView.frame = CGRect(x: 0, y: -kGameViewHeight, width: kScreenWidth, height: kGameViewHeight)
        return gameView
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.purple
        // 6.1设置UI
        setupUI()
        // 7.0 发送网络请求,建立extension
        loadData()
    }

}


// 6.1 MARK:- 设置UI界面的内容 --> 6.2 设置全局UICollectionView属性
extension RecommendViewController {
    private func setupUI() {
        // 6.3 将UICollectionView添加到控制器的View中 --> 6.4 添加内容，Controller成为CollectionView的控制元
        view.addSubview(collectionView)

        // 9.4 将PageHeaderCycleView添加到CollectionView中
        collectionView.addSubview(headerPhotoCycleView)

        // 10.2.2 将gameView添加到collectionView中
        collectionView.addSubview(gameView)

        // 9.6 设置collectionView的内边距使其能够显示在collectionView的顶部（给他一个在collectionView显示的空间 ---> 9.7 在xib中拖拽放置UICollectionView用以显示循环滚动的图片和pageControl --->  9.8 显示数据（必须设置数据源（右键xib，将datasouce拖拽至RecommandCycleViewController（左侧面板）））
        collectionView.contentInset = UIEdgeInsets(top: kHeaderPhotoCycleViewHeight + kGameViewHeight, left: 0, bottom: 0, right: 0)
    }
}

// 6.5 遵守UICollectionView的dataSource的协议（必实现numberOfItemsInSection和cellForItemAt）以及遵守UICollectionViewDelegateFlowLayout协议
extension RecommendViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // 6.5.1 将要实现的UI中有12组分组，实现这个方法
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return recommendVM.anchorGroups.count
//        return 12
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 网络请求后这个就不能写死了
        /*if section == 0 {
            return 8
        }
        return 4*/
        let group = recommendVM.anchorGroups[section]
        return group.anchors.count //这一步完成后，网络请求就差不多完成了 ---> 7.8 （暂时定7.8）取出模型, 变更Header的具体内容
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 8.0 取出模型对象
        let group = recommendVM.anchorGroups[indexPath.section]
        let anchor = group.anchors[indexPath.item]

        // 6.5.1 获取Cell(按Section不同区分不同的Cell),但想要获取Cell，必须先要注册Cell --> 6.5.2 注册Cell
//        var cell: UICollectionViewCell

        // 8.7 对RecommendViewController中提起cell的部分也做一个优化
        var cell: CollectionBaseCell

        if indexPath.section == 1 {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: kLargerCellID, for: indexPath) as! CollectionLargerCell
            // 8.1.2 将对应的数据传入到相应的Cell中 --> 8.2 对xib中的控件进行设置 --> 8.7后8.8 因为变成了继承关系，所以到后面统一处理
            // cell.anchor = anchor

        } else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: kNormalCellID, for: indexPath) as! CollectionNormalCell
            // 8.1.2 将对应的数据传入到相应的Cell中 --> 8.2 对xib中的控件进行设置 --> 8.7后8.8 因为变成了继承关系，所以到后面统一处理
            // cell.anchor = anchor
        }

        // 8.8 统一处理cell.anchor = anchor,将模型赋值给Cell
        cell.anchor = anchor

        // return cell //这一步完了，没结束，如果只是这样的话cell的大小是不能随section的不同而改变的，因此还要让这个class实现UICollectionView的Delegate --> 6.8 让self实现UICollectionViewDelegate, PS:8.0后这个移到了上面，因为要和json关联改变样式（强转成对应的Cell类型）
        // PPS 8.7后8.8 因为变成了继承关系，所以到后面统一处理,所以这里return cell又回来了
        return cell
    }

    // 6.5.5 和取Cell一样，取头,用这个方法：---> 6.7定义cell的内容
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        // 1.取出sectionHeaderView
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kHeaderViewID, for: indexPath) as! CollectionHeaderView
        // 7.8 （暂时定7.8）取出模型, 变更Header的具体内容 ---> 7.9 将这些数据传入到CollectionHeaderView.xib ---> 7.10 上面这个变成 as! CollectionHeaderView,这样可以直接assign这个group --> 完
        // let group = recommendVM.anchorGroups[indexPath.section]
        // headerView.group = group
        headerView.group = recommendVM.anchorGroups[indexPath.section]
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

// 7.0 建立网络请求的extension，本来应该是这样的，但是现在引入ViewModal这一概念，所有网络请求放进这个Modal,这里请求ViewModald中的方法
extension RecommendViewController {
    private func loadData() {
        recommendVM.requestData(finishCallback: {
            self.collectionView.reloadData()

            // 10.4.1 将数据传递给GameView --> 10.4.2 监听数据的改变
            self.gameView.groups = self.recommendVM.anchorGroups
        })

        // 9.15.2 RecommendViewController中的loadData调用这个方法 --> 9.15.3 解析数据
        recommendVM.requestCycleData(finishCallback: {
            // 9.15.3(6) RecommendViewController中使用这个数据 ---> 9.15.3(7) 传递这个数据到RecommendCycleView中 ---> 9.15.3(8) Pre展示这个View
//            recommendVM.pageHeaderCycleModels
            self.headerPhotoCycleView.cycleModels = self.recommendVM.pageHeaderCycleModels
        })
    }
}
