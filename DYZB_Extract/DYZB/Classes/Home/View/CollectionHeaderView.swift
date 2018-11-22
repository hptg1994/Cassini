//
//  CollectionHeaderView.swift
//  DYZB
//
//  Created by 何品泰高 on 2018/11/16.
//  Copyright © 2018 何品泰高. All rights reserved.
//

import UIKit

// 6.6 创建自定义的Header(Header 和Footer 一般用UICollectionReusableView)(同时创建xib) --> 先在xib中布局好layout ---> 6.6.1 注册xib
class CollectionHeaderView: UICollectionReusableView {

    //  7.9 将这些数据传入到CollectionHeaderView.xib
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var moreBtn: UIButton!
    
    // 定义模型属性
    var group: AnchorGroup? {
        didSet {
            titleLabel.text = group?.tag_name
            iconImageView.image = UIImage(named: group?.icon_name ?? "home_header_normal")
        }
    }
}


// MARK:- 从xib中快速创建的类方法
extension CollectionHeaderView {
    class func collectionHeaderView() -> CollectionHeaderView {
        return Bundle.main.loadNibNamed("CollectionHeaderView", owner: nil,options: nil)?.first as! CollectionHeaderView
    }
}
