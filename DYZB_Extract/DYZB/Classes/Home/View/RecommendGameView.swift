//
//  RecommendGameView.swift
//  DYZB
//
//  Created by 何品泰高 on 2018/11/18.
//  Copyright © 2018 何品泰高. All rights reserved.
//

import UIKit

private let kGameCellID = "kGameCellID"
private let kEdgeInsetMargin: CGFloat = 10

class RecommendGameView: UIView {

    //MARK:- 10.4 定义数据的一个属性 --> 10.4.1 将数据传递给GameView
    var groups: [BaseGameModel]? {
        // 10.4.2 监听数据的改变 --> 10.4.3 取group中的数据
        didSet {
            collectionView.reloadData()
        }
    }

    //MARK:- 控件属性
    @IBOutlet weak var collectionView: UICollectionView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // 10.2.4 取消自动缩放 ---> 10.3 开始放东西，在xib中放一个collectionView ---> 10.4 要让其显示东西，右键xib中的collectionView然后拖拽其dataSource至RecommandGameView ---> 10.4.1 遵守DataSource协议
        autoresizingMask = []

        // 10.4.2 注册cell --> 10.4.3直接在xib的属性面板中设置cell的宽度和长度，这样就不用代码来设置了, PS: 10.4.4 自定义cell， 并且在cell中展示这些数据后这个注册就变成用UINib了 
        collectionView.register(UINib(nibName: "CollectionGameCell", bundle: nil), forCellWithReuseIdentifier: kGameCellID)

        // 10.5给collectionView添加内边距
        collectionView.contentInset = UIEdgeInsets(top: 0, left: kEdgeInsetMargin, bottom: 0, right: kEdgeInsetMargin)
    }
}


extension RecommendGameView {
    // 10.1 快速创建的类方法 ---> 10.2 控制器中创建并添加这个View ---> 10.2.1 创建懒加载属性
    class func recommendGameView() -> RecommendGameView {
        return Bundle.main.loadNibNamed("RecommendGameView", owner: nil, options: nil)?.first as! RecommendGameView
    }
}

// 10.4.1 遵守DataSource协议 ---> 10.4.2 注册cell
extension RecommendGameView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groups?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kGameCellID, for: indexPath) as! CollectionGameCell
        // 10.4.3 取group中的数据,将这些数据直接赋值给CollectionGameCell中相对应的属性 ---> 10.4.4 自定义cell， 并且在cell中展示这些数据
        cell.group = groups![indexPath.item]
        return cell
    }

}
