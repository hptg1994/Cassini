//
//  PageTitleView.swift
//  DYZB
//
//  Created by 何品泰高 on 2018/11/14.
//  Copyright © 2018 何品泰高. All rights reserved.
//

import UIKit

// 滚动条的高度
private let kScrollLineHeight: CGFloat = 2

class PageTitleView: UIView {

    // MARK:- 定义属性
    private var currentIndex: Int = 0
    private var titles: [String]

    // MARK:- 添加懒加载
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.isPagingEnabled = false
        scrollView.bounces = false
        return scrollView
    }()

    private lazy var titleLabels: [UILabel] = [UILabel]()

    private lazy var scrollLine: UIView = {
        let scrollLine = UIView()
        scrollLine.backgroundColor = UIColor.orange
        return scrollLine
    }()

    // MARK:- 自定义构造函数(自定义构造函数需实现required init?这个东西)
    init(frame: CGRect, titles: [String]) {
        self.titles = titles
        super.init(frame: frame)
        // 设置UI界面
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


//MARK:- 设置UI界面
extension PageTitleView {
    private func setupUI() {
        // 1. 添加UIScrollView
        addSubview(scrollView)
        scrollView.frame = bounds
        // 2.添加title对应的label
        setupTitleLabels()
        // 3. 设置底线和滚动的滑块
        setupButtomMenuAndScrollLine()
    }

    private func setupTitleLabels() {
        // 0.确定label的一些frame的值
        let labelWidth: CGFloat = frame.width / CGFloat(titles.count)
        let labelHeight: CGFloat = frame.height - kScrollLineHeight
        let labelY: CGFloat = 0

        for (index, title) in titles.enumerated() {
            //1. 创建UILabel
            let label = UILabel()
            //2.设置Label的属性
            label.text = title
            label.tag = index
            label.font = UIFont.systemFont(ofSize: 16.0)
            label.textColor = UIColor.darkGray
            label.textAlignment = .center
            //3.设置label的frame
            let labelX: CGFloat = labelWidth * CGFloat(index)
            label.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
            //4.将label添加到scrollView中
            scrollView.addSubview(label)
            // 将生成的Label，存储到这个titleLabels:[UILabel]，将他们的信息存储起来，以后要用到
            titleLabels.append(label)

            // 5. 给Label添加手势
            label.isUserInteractionEnabled = true
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(self.titleLabelClick(_:)))
            label.addGestureRecognizer(tapGes)
        }
    }

    private func setupButtomMenuAndScrollLine() {
        // 1.添加底线
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor.lightGray
        let lineHight: CGFloat = 0.5
        bottomLine.frame = CGRect(x: 0, y: frame.height - lineHight, width: frame.width, height: lineHight)
        // 直接加到当前View而不是scrollView
        addSubview(bottomLine)
        // 2.添加scrollLine ---> 添加全局scrollLine
        // 2.1 获取第一个Label --> 本想用scrollView.subviews来获得这个firstLabel，但是这样不好，应该用一个数组存储起来，所以有了 --> private lazy var titleLabels:[UILabel] = [UILabel]()
        guard let firstLabel = titleLabels.first else {
            return
        }
        firstLabel.textColor = UIColor.orange

        // 2.2 设置scrollLine的属性
        scrollView.addSubview(scrollLine)
        scrollLine.frame = CGRect(x: firstLabel.frame.origin.x, y: frame.height - kScrollLineHeight, width: firstLabel.frame.width, height: kScrollLineHeight)
    }
}

//MARK:- 监听Label的点击
extension PageTitleView {
    @objc private func titleLabelClick(_ tapGes: UITapGestureRecognizer){
        // 1.获取当前label
        guard let currentLabel = tapGes.view as? UILabel else { return }

        // 2.获取之前的Label
        let oldLabel = titleLabels[currentIndex]

        // 3.切换文字颜色
        currentLabel.textColor = UIColor.orange
        oldLabel.textColor = UIColor.darkGray
        // 保存最新Label的下标值
        currentIndex = currentLabel.tag


        
    }
}
