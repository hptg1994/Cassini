//
//  ImageViewController.swift
//  Cassini
//
//  Created by 何品泰高 on 2017/6/23.
//  Copyright © 2017年 何品泰高. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {

    var imageURL : URL? {
        didSet{
            image = nil
            if view.window != nil{
                fetchImage()
            }
            
        }
    }
    
    private func fetchImage(){
        if let url = imageURL{
            let urlContents = try? Data(contentsOf: url)
            if let imageData  = urlContents{
                image = UIImage(data: imageData)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.addSubview(imageView)
        imageURL = DemoURL.stanford
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if image == nil{
            fetchImage()
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet{
            scrollView.delegate = self
            scrollView.minimumZoomScale = 0.03
            scrollView.maximumZoomScale = 1.0
            scrollView.contentSize = imageView.frame.size
            scrollView.addSubview(imageView)
        }
    }
    
    private var imageView = UIImageView()
    
    fileprivate var image : UIImage?{
        get {
            return imageView.image
        }
        set{
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView?.contentSize = imageView.frame.size
        }
    }
    
    extension ImageViewController:UIScrollViewDelegate{
        func viewForZooming(in scorllView:UIScrollView) -> UIView? {
            return imageView
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
