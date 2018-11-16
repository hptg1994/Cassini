//
//  PageTitleView.swift
//  DYZB
//
//  Created by 何品泰高 on 2018/11/14.
//  Copyright © 2018 何品泰高. All rights reserved.
//

import UIKit

/* 5.2 此，在点击不同的Title Label的时候。相应的页面也要切换，怎么办？因为它们都是HomeView旗下的两个子View，所以应该是子 -> 父 -> 子 这样传递消息，所以这里我们用代理的方式来实现 ---> 5.2.1 设置代理属性*/
protocol PageTitleViewDelegate: class {
    func pageTitleView(_ titleView: PageTitleView, selectedIndex index: Int)
}

/* 定义全局常量*/
// 滚动条的高度
private let kScrollLineHeight: CGFloat = 2
// label没被选中时的一个颜色，是一个tuple
private let kNormalColor: (CGFloat, CGFloat, CGFloat) = (85, 85, 85)
private let kSelectColor: (CGFloat, CGFloat, CGFloat) = (255, 128, 0)

// 3.1 建立PageTitleView的Class ---> 3.1.1 构造函数 ---> 3.2 初始化PageTitleView
class PageTitleView: UIView {

    // MARK:- 定义属性
    private var currentIndex: Int = 0
    private var titles: [String]

    // 5.2.1 设置代理属性 ---> 5.2.2 通知代理做事情
    weak var delegate: PageTitleViewDelegate?

    // 3.1.2(1.1) 设置懒加载 --> 3.1.2(1.2) 规定scrollView在parentView的位置
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.isPagingEnabled = false
        scrollView.bounces = false
        return scrollView
    }()

    private lazy var titleLabels: [UILabel] = [UILabel]()

    //  3.1.2(3.1) 设置最初的下滑底线ScrollLine的样式 ---> 3.1.2(3.2) 获取第一个Label
    private lazy var scrollLine: UIView = {
        let scrollLine = UIView()
        scrollLine.backgroundColor = UIColor.orange
        return scrollLine
    }()

    // 3.1.1 自定义构造函数(自定义构造函数需实现required init?这个东西)
    init(frame: CGRect, titles: [String]) {
        self.titles = titles
        super.init(frame: frame)
        // 3.1.2设置UI界面
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


//MARK:- 设置UI界面
extension PageTitleView {
    // 3.1.2 设置UI界面
    private func setupUI() {
        // 3.1.2(1) 添加UIScrollView --> 3.1.2(1.1) 设置懒加载
        addSubview(scrollView)
        // 3.1.2(1.2) 规定scrollView在parentView的位置 --> 3.1.2(2)
        scrollView.frame = bounds

        // 3.1.2(2) 添加title对应的label
        setupTitleLabels()

        // 3.1.2(3) 设置底线和滚动的滑块
        setupButtomMenuAndScrollLine()
    }

    // 3.1.2(2) 添加title对应的label
    private func setupTitleLabels() {
        // 0.确定每一g个label的frame的值和其大小（长宽高）
        let labelWidth: CGFloat = frame.width / CGFloat(titles.count)
        let labelHeight: CGFloat = frame.height - kScrollLineHeight
        let labelY: CGFloat = 0

        // 3.1.2(2.1)因为有四个Title Lable 所以循环四次，分别添加进scrollView
        for (index, title) in titles.enumerated() {
            //1. 创建UILabel
            let label = UILabel()
            //2.设置Label的属性
            label.text = title
            label.tag = index // 设置label的标签
            label.font = UIFont.systemFont(ofSize: 16.0)
            label.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
            label.textAlignment = .center
            //3.设置label的frame
            let labelX: CGFloat = labelWidth * CGFloat(index)
            label.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
            //4.将label添加到scrollView中
            scrollView.addSubview(label)
            //4.1 将生成的Label，存储到这个titleLabels:[UILabel]，将他们的信息存储起来，以后要用到
            titleLabels.append(label)

            //5.0 给Label添加手势 --> 5.1 监听Label点击
            label.isUserInteractionEnabled = true
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(self.titleLabelClick(_:)))
            label.addGestureRecognizer(tapGes)
        }
    }

    // 3.1.2(3) 设置底线和滚动的滑块 ---> 3.1.2(3.0)添加底线
    private func setupButtomMenuAndScrollLine() {

        // 3.1.2(3.0)添加底线（一条下划线为区分PageTitleView和PageContentView）--->3.1.2(3.1)设置最初的下滑底线ScrollLine的样式
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor.lightGray
        let lineHight: CGFloat = 0.5
        bottomLine.frame = CGRect(x: 0, y: frame.height - lineHight, width: frame.width, height: lineHight)
        // 直接加到当前View而不是scrollView
        addSubview(bottomLine)

        // 3.1.2(3.1)(见上)设置最初的下滑底线ScrollLine的样式
        // 3.1.2(3.2) 获取第一个Label的信息，本想用scrollView.subviews来获得这个firstLabel，但是这样不好，应该用一个数组存储起来，所以有了:private lazy var titleLabels:[UILabel] = [UILabel]()
        guard let firstLabel = titleLabels.first else {
            return
        }
        firstLabel.textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)

        // 3.1.2(3.3) 设置scrollLine的属性(添加到scrollView的subview + 它的位置) --->
        scrollView.addSubview(scrollLine)
        scrollLine.frame = CGRect(x: firstLabel.frame.origin.x, y: frame.height - kScrollLineHeight, width: firstLabel.frame.width, height: kScrollLineHeight)
    }
}

//5.1 监听Label的点击
extension PageTitleView {
    @objc private func titleLabelClick(_ tapGes: UITapGestureRecognizer) {
        // 1.获取当前label
        guard let currentLabel = tapGes.view as? UILabel else {
            return
        }
        // 2.获取之前的Label
        let oldLabel = titleLabels[currentIndex]

        // 3.切换文字颜色
        currentLabel.textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
        oldLabel.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)

        // 4.保存最新Label的下标值 --> 之前label.tag = index
        currentIndex = currentLabel.tag

        // 5.滚动条位置发生改变
        let scrollLineX = CGFloat(currentIndex) * scrollLine.frame.width;
        UIView.animate(withDuration: 0.15) {
            self.scrollLine.frame.origin.x = scrollLineX
        }

        //5.2.2 通知代理做事情(传参数) --> 然后找人成为他的代理(取参数)---> 5.3 成为PageTitleViewDelegate的代理
        delegate?.pageTitleView(self, selectedIndex: currentIndex)

    }
}

//5.7.5 接受来自Home PageContentViewDelegate的数据
extension PageTitleView {
    func setTitleWithProgress(progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        // 5.7.6 对传进来的参数做一些设置
        // 1.取出sourceLabel/targetLabel
        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]

        // 2. 处理滑块的逻辑
        let moveTotalX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
        let moveX = moveTotalX * progress // 此乃要滑动多少
        scrollLine.frame.origin.x = sourceLabel.frame.origin.x + moveX

        // 3.处理颜色渐变
        //3.1 取出变化的范围
        let colorDelta = (kSelectColor.0 - kNormalColor.0, kSelectColor.1 - kNormalColor.1, kSelectColor.2 - kNormalColor.2)
        //3.2 变化sourceLabel
        sourceLabel.textColor = UIColor(r: kSelectColor.0 - colorDelta.0 * progress, g: kSelectColor.1 - colorDelta.1 * progress, b: kSelectColor.2 - colorDelta.2 * progress)
        //3.3 变化targetLabel
        targetLabel.textColor = UIColor(r: kNormalColor.0 + kSelectColor.0 * progress, g: kNormalColor.1 + kSelectColor.1 * progress, b: kNormalColor.2 + kSelectColor.2 * progress)

        // 4.记录最新的index
        currentIndex = targetIndex

    }
}
