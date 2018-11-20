//
//  GameViewController.swift
//  DYZB
//
//  Created by 何品泰高 on 2018/11/20.
//  Copyright © 2018 何品泰高. All rights reserved.
//

import UIKit

private let kEdgeMargin:CGFloat = 10
private let kItemWidth:CGFloat = (kScreenWidth - 2 * kEdgeMargin) / 3
private let kItemHeight:CGFloat = kItemWidth * 6 / 5
private let kGameCellID = "kGameCellID"

class GameViewController: UIViewController {

    // 11.7.1 懒加载GameModel（初始化其instance） ---> 11.7.2 调用这个gameVM
    fileprivate lazy var gameVM: GameViewModel = GameViewModel()
    
    // 11.2 对i进行数据展示的UICollectionView进行懒加载 --> 11.2.1 注册cell
    fileprivate lazy var collectionView: UICollectionView = {[unowned self] in
        // 1. 创建布局
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: kItemWidth, height: kItemHeight)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: kEdgeMargin, bottom: 0, right: kEdgeMargin)
        // 2. 创建jUICollectionView
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        // 11.2.1 注册cell(直接注册CollectionGameCell，因为这个GameCell 是用xib进行描述的，所以要用UINib进行) ---> 11.2.2 设置当前控制器成为他的数据源
        collectionView.register(UINib(nibName: "CollectionGameCell", bundle: nil), forCellWithReuseIdentifier: kGameCellID)
        // 11.2.2 设置当前控制器成为他的数据源 --> 11.2.3 遵守DataSource的协议
        collectionView.dataSource = self
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
//        loadData()
    }
}

extension GameViewController {
    // 11.2.3 将这个collectionView添加进这个UIViewController --> 11.3 创建这个View对应的ViewModal
    fileprivate func setupUI(){
        view.addSubview(collectionView)
    }
}

// 11.7 调用这个Model --> 11.7.1 懒加载GameModel（初始化其instance）
extension GameViewController {
    fileprivate func loadData() {
        // 11.7.2 调用这个gameVM ---> 11.7.3 依据实际情况设置collecitonView's numberOfItemsInSection
        gameVM.loadAllGameData { 
            self.collectionView.reloadData()
        }
    }
}

//  11.2.2 设置当前控制器成为他的数据源(实现两个方法，一个显示有多少cell和获取cell) --> 11.2.3 将这个collectionView添加进这个UIViewController
extension GameViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 11.7.3 依据实际情况设置collecitonView's numberOfItemsInSection --> 11.7.4 取模型
        return gameVM.games.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 1.获取cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kGameCellID, for: indexPath) as! CollectionGameCell
        // 11.7.4 取模型,将数据传递给已强制转换的成CollectionGameCell的cell中group属性
        let gameModel = gameVM.games[indexPath.item]
        cell.group = gameModel


        return cell
    }
}
