//
//  RecommendViewController.swift
//  DYZB
//
//  Created by 何品泰高 on 2018/11/16.
//  Copyright © 2018 何品泰高. All rights reserved.
//

import UIKit

// 6.0 创建推荐页面的Class
class RecommendViewController: BaseAnchorViewController {

    // MARK:- 属性
    // 7.0 发送网络请求,建立extension,设置网络请求的懒加载 ---> 7.3建立这个RecommendViewModal这个Class并完善requestData这个function
    private lazy var recommendVM: RecommendViewModal = RecommendViewModal()

    // 9.3 创建RecommendCycleView，懒加载
    private lazy var headerPhotoCycleView: RecommendCycleView = {
        let cycleView = RecommendCycleView.recommendCycleView() // ---> 任何一个View都要有frame才能显示出来
        cycleView.frame = CGRect(x: 0, y: -(kHeaderPhotoCycleViewHeight + kGameViewHeight), width: kScreenWidth, height: kHeaderPhotoCycleViewHeight) // 这个cycleView应该加到CollectionView里面这样才能随着collectionView的滚动而一起滚动 ---> 9.4 将PageHeaderCycleView添加到CollectionView中
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

}


// 6.1 MARK:- 设置UI界面的内容 --> 6.2 设置全局UICollectionView属性
extension RecommendViewController {
    override func setupUI() {
        // 12.3.10 先调用super.setupUI()
        super.setupUI()

        // 9.4 将PageHeaderCycleView添加到CollectionView中
        collectionView.addSubview(headerPhotoCycleView)

        // 10.2.2 将gameView添加到collectionView中
        collectionView.addSubview(gameView)

        // 9.6 设置collectionView的内边距使其能够显示在collectionView的顶部（给他一个在collectionView显示的空间 ---> 9.7 在xib中拖拽放置UICollectionView用以显示循环滚动的图片和pageControl --->  9.8 显示数据（必须设置数据源（右键xib，将datasouce拖拽至RecommandCycleViewController（左侧面板）））
        collectionView.contentInset = UIEdgeInsets(top: kHeaderPhotoCycleViewHeight + kGameViewHeight, left: 0, bottom: 0, right: 0)
    }
}

// 7.0 建立网络请求的extension，本来应该是这样的，但是现在引入ViewModal这一概念，所有网络请求放进这个Modal,这里请求ViewModald中的方法
extension RecommendViewController {
    override func loadData() {
        // 0.给父类中的ViewModel进行赋值
        baseVM = recommendVM
        recommendVM.requestData(finishCallback: {
            self.collectionView.reloadData()
            // 10.4.1 将数据传递给GameView --> 10.4.2 监听数据的改变
            var groups = self.recommendVM.anchorGroups
            // 移除热门和颜值这两组数据
            groups.removeFirst()
            groups.removeFirst()
            // 添加滑到最后的"更多组"
            let moreGroup = AnchorGroup()
            moreGroup.tag_name = "更多"
            groups.append(moreGroup)
            self.gameView.groups = groups
        })

        // 9.15.2 RecommendViewController中的loadData调用这个方法 --> 9.15.3 解析数据
        recommendVM.requestCycleData(finishCallback: {
            // 9.15.3(6) RecommendViewController中使用这个数据 ---> 9.15.3(7) 传递这个数据到RecommendCycleView中 ---> 9.15.3(8) Pre展示这个View
//            recommendVM.pageHeaderCycleModels
            self.headerPhotoCycleView.cycleModels = self.recommendVM.pageHeaderCycleModels
        })
    }
}

// 12.3.11 继承完后发现颜值那一块的Cell的大小不正确，即子类对父类的实现不满意要重新实现
extension RecommendViewController: UICollectionViewDelegateFlowLayout {
    //12.3.11(1) 重新实现cell大小的function ---> 12.3.11(2) 重写使用哪一个cell（xib）的方法
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 1 {
            return CGSize(width: kNormalItemWidth , height: kLargerItemHeight)
        }
        return CGSize(width: kNormalItemWidth , height: kNormalItemHeight)
    }

    // 12.3.11(2) 重写使用哪一个cell的方法
    public override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 1 {
            let largerCell = collectionView.dequeueReusableCell(withReuseIdentifier: kLargerCellID, for: indexPath) as! CollectionLargerCell
            largerCell.anchor = recommendVM.anchorGroups[indexPath.section].anchors[indexPath.item]
            return largerCell
        } else {
            return super.collectionView(collectionView, cellForItemAt: indexPath)
        }
    }
}
