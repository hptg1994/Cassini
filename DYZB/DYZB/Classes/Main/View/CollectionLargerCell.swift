//
//  CollectionLargerCell.swift
//  DYZB
//
//  Created by 何品泰高 on 2018/11/16.
//  Copyright © 2018 何品泰高. All rights reserved.
//

import UIKit
import Kingfisher

class CollectionLargerCell: CollectionBaseCell{
    
    // 8.3 对控件进行设置 --> 8.4 设置内容
    @IBOutlet weak var cityBtn: UIButton!
    
    override var anchor: AnchorModal?{
        // 8.4 设置内容 + // 8.6.2 LargerCell中如法炮制 --> 8.7 对RecommendViewController中提起cell的部分也做一个优化，因为那里是分别对LargeCell和NormalCell分别建Cell,但现在这个变继承了，那里同业也可以变成继承
        didSet{
            super.anchor = anchor
            // 3.所在城市
            cityBtn.setTitle(anchor?.anchor_city, for: .normal)
        }
    }

}
