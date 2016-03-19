//
//  ViewController.swift
//  photoReview
//
//  Created by ling on 3/19/16.
//  Copyright © 2016 Ling. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {
    

    @IBOutlet weak var scrollView: UIScrollView!
    
    var imageView: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1 设定图片，把imageview 加入scrollview
        let image = UIImage(named: "photo1.png")!
        imageView = UIImageView(image: image)
        imageView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size:image.size)
        scrollView.addSubview(imageView)
        
        // 2 设定scrollview 内容大小
        scrollView.contentSize = image.size
        
        // 3 设定手势 双击
        var doubleTapRecognizer = UITapGestureRecognizer(target: self, action: "scrollViewDoubleTapped:")
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.numberOfTouchesRequired = 1
        scrollView.addGestureRecognizer(doubleTapRecognizer)
        
        // 4 最小放大值为图片大小，
        let scrollViewFrame = scrollView.frame
        let scaleWidth = scrollViewFrame.size.width / scrollView.contentSize.width
        let scaleHeight = scrollViewFrame.size.height / scrollView.contentSize.height
        let minScale = min(scaleWidth, scaleHeight);
        scrollView.minimumZoomScale = minScale;
        
        // 5 最大放大值为1，保证无法放大过图片本身像素
        scrollView.maximumZoomScale = 1.0
        scrollView.zoomScale = minScale;
        
        // 6 图片居中func
        centerScrollViewContents()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Navigation
    
    // 防止如果图片太小，scrollview默认图片处于左上角
    func centerScrollViewContents() {
        let boundsSize = scrollView.bounds.size
        var contentsFrame = imageView.frame
        
        if contentsFrame.size.width < boundsSize.width {
            contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0
        } else {
            contentsFrame.origin.x = 0.0
        }
        
        if contentsFrame.size.height < boundsSize.height {
            contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0
        } else {
            contentsFrame.origin.y = 0.0
        }
        
        imageView.frame = contentsFrame
    }
    
    
    /*
    First, you need to work out where the tap occurred within the image view. You’ll use this to zoom in directly on that point, which is probably what you’d expect as a user.
    Next, you calculate a zoom scale that’s zoomed in 150%, but capped at the maximum zoom scale you specified in viewDidLoad.
    Then you use the location from step #1 to calculate a CGRect rectangle that you want to zoom in on.
    Finally, you need to tell the scroll view to zoom in, and here you animate it to look pretty too.
    */
    
    func scrollViewDoubleTapped(recognizer: UITapGestureRecognizer) {
        // 1 定义双击反应区域
        let pointInView = recognizer.locationInView(imageView)
        
        // 2
        var newZoomScale = scrollView.zoomScale * 1.5
        newZoomScale = min(newZoomScale, scrollView.maximumZoomScale)
        
        // 3 如果图片过小，被放大，重新计算反应区域
        let scrollViewSize = scrollView.bounds.size
        let w = scrollViewSize.width / newZoomScale
        let h = scrollViewSize.height / newZoomScale
        let x = pointInView.x - (w / 2.0)
        let y = pointInView.y - (h / 2.0)
        
        let rectToZoomTo = CGRectMake(x, y, w, h);
        
        // 4 双击后放大。
        scrollView.zoomToRect(rectToZoomTo, animated: true)
    }
    
    /*
    After set up ViewController as a UIScrollViewDelegate, implement a couple of needed functions in that protocol. Add the following method to the class:
    */
    func viewForZoomingInScrollView(scrollView: UIScrollView!) -> UIView! {
        return imageView
    }

    
    /*
    Scroll view’s zooming. telling it which view should be made bigger and smaller when the scroll view is pinched, which is the imageView.
    The scroll view will call this method after the user finishes zooming. Here, you need to re-center the view – if you don’t, the scroll view won’t appear to zoom naturally; instead, it will sort of stick to the top-left.
    */
    func scrollViewDidZoom(scrollView: UIScrollView!) {
        centerScrollViewContents()
    }
    
    /*
    The scroll view will call this method after the user finishes zooming
    */
}
