//
//  CollectionGameCell.swift
//  DYZB
//
//  Created by 何品泰高 on 2018/11/19.
//  Copyright © 2018 何品泰高. All rights reserved.
//

import UIKit
import Kingfisher

// 这个Cell的高度和宽度可以直接写死，直接在xib中属性面版中将高度和宽度分别设置成90和80，这样子就不用用代码来定义了
class CollectionGameCell: UICollectionViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    //MARK:- 定义模型属性
    var group: AnchorGroup? {
        didSet { 
            titleLabel.text = group?.tag_name
            let iconUrl = URL(string: group?.icon_url ?? "")!
            iconImageView.kf.setImage(with: iconUrl, placeholder: UIImage(named: "home_more_btn"))

        }
    }
    
    

}
