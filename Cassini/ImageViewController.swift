//
//  ImageViewController.swift
//  Cassini
//
//  Created by 何品泰高 on 2017/6/23.
//  Copyright © 2017年 何品泰高. All rights reserved.
//

// this is a model 

// first things we need to do is: What is my model? Because the mode is what this MVC does.
// this would be a image,so create a var imageURl

import UIKit

class ImageViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.addSubview(imageView)
        imageURL = DemoURL.stanford  //go up to the fetchImage.url and cause the fetchImage() func happen
    }
    
    
// first things is to have a imageURL
    var imageURL : URL? {
        didSet{
            image = nil  // clear out what ever the image that I have
            if view.window != nil{
                fetchImage()
            }
        }
    }

    fileprivate var imageView = UIImageView()   //UIImageView(frame:CGRect.zero)
    //If need to set an image to the imageView,gonna need to de things like change the frame of the imageView,so need to create a private var image:UIImage
    // and it is gonna be computed and it is gonna have a get and set,so every time get and set image can do other stuff
    fileprivate var image : UIImage?{ // at some point, want my imageView to be nil, So UIImage is set to be optional
        get {
            return imageView.image  // 如字段的意思 //就是imageView 这个框架里面放image
        }
        set{
            imageView.image = newValue //UIImageView的image会被设置成newValue
            imageView.sizeToFit() // fit the size
            scrollView?.contentSize = imageView.frame.size  //set new contentSize
        }
    }

    
    private func fetchImage(){
        if let url = imageURL{
            let urlContents = try? Data(contentsOf: url) // Data:load up your bag of bits with whatever's at this url on the internet // try?: if is  throws,it can come back nil
            if let imageData  = urlContents{
                image = UIImage(data: imageData)
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {  //doing this when the image not on screen already
        super.viewWillAppear(animated)
        if image == nil{ // if I don't have an image yet so far,then go fetch it
            fetchImage()
        }
    }
    // So: if view.window != nil{fetchImage()} and if image == nil{fetchImage()},they both together combination is going to wait to fetch it until view will appear,that  is kind of delay
    // if I did somthing that caused the image to change,it would......8

    @IBOutlet weak var scrollView: UIScrollView! {
        didSet{
            scrollView.delegate = self  //delegate: to make zooming work,the scroll view need to know which subview you want to have the transform change,and it does this by asking the delegate
            scrollView.minimumZoomScale = 0.03
            scrollView.maximumZoomScale = 1.0
            scrollView.contentSize = imageView.frame.size // 没有这个滑不了
            scrollView.addSubview(imageView)
        }
    }
    
    }



extension ImageViewController:UIScrollViewDelegate{
    func viewForZooming(in scorllView:UIScrollView) -> UIView? { // automatically offer me
        return imageView  //return to UIImageView
    }
}





//first thins,the image is load from the Internet,so the first things is create a url ->
//var imageURL:URL? (could be nil)

//and it did load a image,so need to create a ImageView which is call: 
//private var imageView = UIImageView()

//after set the imageView,I'm goona need to do things like change the frame of my imageView and things like that: ....and it is a coumputable
//private var image: UIImage? {
//    get{
//        return imageView.image
//    }
//    set{ //if
//        imageView.image = newValue
//        imageView.sizeToFit()
//    }
//}

// now put the imageView into the hierarchy in code
// override func viewDidLoad() {
//     super.viewDidLoad()
//     view.addSubview(imageView)
//     imageURL = DemoURL.stanford
//  }

//get the image from imageURL using the property observe(property feature)
//var imageURL:URL? {
//    didSet{
//        image = nil // first need to clean what the image is on
//        if view.window != nil { // that I am on screen
//        fetching() // method get the url
//      }
//   }
//}

//func fetching(): the purpose of it is: imageURL might be an internet URL and this might be slow internet,this might be take a long time
//private func fetching() {   // first, have to make sure if I have a url to fetch
//    if let url = imageURL{
//        let urlContents = try? Data(contentsOf: url)  //load up your bag of bits with whatever's at it is// using try? : if I can't get it, then I just won't show it.
//        if let imageData = urlContents {
//            image = UIImage(data:imageData)
//    }
//}

//后来我们发现，有一点不好，as viewDidLoad run,the ferching() will immediately happen,which would go out the internet and grap the image，这样不好，当我都还没有开始准备要点他们的时候，他们就在开始在那里load了, So I really only wanna go fetch this URL when this view controller is going to appear on screen for sure.SO PUT IT IN VIEWWILLAPPEAR()
//但是，当我们正在使用的时候，不能继续使用ViewWILlAppear，so we might make so check,

//override func viewWillAppear(_ animated: Bool) {  //doing this when the image not on screen already
//    super.viewWillAppear(animated)
//    if image == nil{ // if I don't have an image yet so far,then go fetch it
//        fetchImage()
//    }
//}

