//
//  CollectionHeaderPageCycleCell.swift
//  DYZB
//
//  Created by 何品泰高 on 2018/11/18.
//  Copyright © 2018 何品泰高. All rights reserved.
//

import UIKit
import Kingfisher

class CollectionHeaderPageCycleCell: UICollectionViewCell {
    
    // MARK:- 控件属性
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    

    // MARK:- 定义模型属性
    // 9.18 将模型传给这个新的Cell ---> 在xib中拖拽控件 --> 9.19 将数据添加进控件
    var cycleModel:PageHeaderCycleModel?{
        // 9.19 将数据添加进控件 --> 9.20 监听图片的滚动并跟着改变右下角的点位置，即设置CollectionView的代理（e.g:监听滚动即设置其代理(因为代理后可以使用其中的方法scrollViewDidScroll)）
        didSet {
            titleLabel.text = cycleModel?.title
            let iconURL = URL(string: cycleModel?.pic_url ?? "")!
            iconImageView.kf.setImage(with: iconURL,placeholder: UIImage(named: "Img_default"))
        }
    }

}

