//
//  CollectionBaseCell.swift
//  DYZB
//
//  Created by 何品泰高 on 2018/11/17.
//  Copyright © 2018 何品泰高. All rights reserved.
//

import UIKit

class CollectionBaseCell: UICollectionViewCell {
    
    // 8.3 对控件进行设置 --> 8.4 设置内容
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var onlineBtn: UIButton!
    @IBOutlet weak var nickNameLabel: UILabel!

    // 8.1.1定义模型属性 ---> 8.1.2回RecommandViewController去传值 ---> 8.6 更改被继承控件中的anchor至override
    var anchor: AnchorModal?{
        didSet {
            // 0.校验模型是否有值
            guard let anchor = anchor else { return }
            // 1. 取出在线人数显示的文字
            var onlineStr:String = ""
            if anchor.online >= 10000 {
                onlineStr = "\(Int(anchor.online / 10000))万在线"
            }else{
                onlineStr = "\(anchor.online)在线"
            }
            onlineBtn.setTitle(onlineStr, for: .normal)

            // 2.取出并显示昵称
            nickNameLabel.text = anchor.nickname

            // 4.显示封面图片
            guard let iconURL = URL(string:anchor.vertical_src) else {return}
            iconImageView.kf.setImage(with:iconURL)
            iconImageView.autoresizingMask = UIView.AutoresizingMask(rawValue: UIView.AutoresizingMask.flexibleBottomMargin.rawValue | UIView.AutoresizingMask.flexibleHeight.rawValue | UIView.AutoresizingMask.flexibleRightMargin.rawValue | UIView.AutoresizingMask.flexibleLeftMargin.rawValue | UIView.AutoresizingMask.flexibleTopMargin.rawValue | UIView.AutoresizingMask.flexibleWidth.rawValue)
            iconImageView.contentMode = UIView.ContentMode.scaleAspectFit
            
        }
    }
}
