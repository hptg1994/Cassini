# 斗鱼直播 -- 适配 iOS10 以上

## 前言

这是一个网络课程，只是当时用的是适配iOS8.0版本，现在重新编译，让其适配iOS10.0以上的版本



## 详细内容

一. 封装**PageTitleView**以及**PageContentView**，处理**PageTitleView**和**PageContentView**的逻辑

![](./Resource/PageTitleView.png)

1. 自定义View，并且自定义构造函数

   ```swift
   //MARK: 懒加载熟悉(利用闭包的形式马上执行)（ pageTitleView的构造器 ）
   private lazy var pageTitleView: PageTitleView = {
       let titleFrame = CGRect(x: 0, y: kStatusBarHeight + kNavigationBarHeight, width: kScreenWidth, height:kTitleViewHeight)
       let titles = ["推荐", "游戏", "娱乐", "趣玩"]
       let titleView = PageTitleView(frame: titleFrame, titles: titles)
       return titleView
   }()
   ```

   **PageTitleView:**

   ```swift
   class PageTitleView: UIView {
        // MARK:- 自定义构造函数(自定义构造函数需实现required init?下面这个东西)
       init(frame: CGRect, titles: [String]) {
           self.titles = titles
           // frame从外面的构造函数来
           super.init(frame: frame)
       }
       required init?(coder aDecoder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
   }
   ```

2. 添加子控View： 

   * UIScrollView：首先全局定义样式

     ```swift
     private lazy var scrollView: UIScrollView = {
             let scrollView = UIScrollView()
             scrollView.showsHorizontalScrollIndicator = false
             scrollView.scrollsToTop = false
             scrollView.isPagingEnabled = false
             scrollView.bounces = false
             return scrollView
         }()
     ```
     然后要在PageTitleView中添加这个scrollView(更改UI应该在class的extension中)
     ```swift
     extension PageTitleView {
     	// 1. 添加UIScrollView
             addSubview(scrollView)
         // 2. 这个scrollView的位置应该在哪里
             scrollView.frame = bounds   
     	// 2.添加title对应的label 这个下面会讲到
             setupTitleLabels()
     	// 3. 设置底线和滚动的滑块 这个下面会讲到
             setupButtomMenuAndScrollLine()
     }
     ```

   * UILabel文字：首先全局定义样式

     ```swift
     private lazy var titleLabels:[UILabel] = [UILabel]()
     ```

     然后要在extension中定义样式：

     ```swift
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
             }
         }
     ```

   * ScrollLine文字下面的下划线：首先全局定义样式 

     ```swift
     private lazy var scrollLine:UIView = {
         let scrollLine = UIView()
         scrollLine.backgroundColor = UIColor.orange
         return scrollLine
     }()
     ```

     然后要定义它的样式：

     ```swift
     private func setupButtomMenuAndScrollLine(){
         // 1.添加底线
         let bottomLine = UIView()
         bottomLine.backgroundColor = UIColor.lightGray
         let lineHight:CGFloat = 0.5
         bottomLine.frame = CGRect(x: 0, y: frame.height-lineHight, width: frame.width, height: lineHight)
         // 直接加到当前View而不是scrollView
         addSubview(bottomLine)
     
         // 2.添加scrollLine ---> 添加全局scrollLine
         // 2.1 获取第一个Label --> 本想用scrollView.subviews来获得这个firstLabel，但是这样不好，应该用一个数组存储起来，所以有了 --> private lazy var titleLabels:[UILabel] = [UILabel]()
         guard let firstLabel = titleLabels.first else { return }
         firstLabel.textColor = UIColor.orange
     
         // 2.2 设置scrollLine的属性
         scrollView.addSubview(scrollLine)
         scrollLine.frame = CGRect(x: firstLabel.frame.origin.x, y: frame.height - kScrollLineHeight, width: firstLabel.frame.width, height: kScrollLineHeight)
     }
     ```
