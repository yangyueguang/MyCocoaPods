//
//  UIImage+Extension.swift
//  Liwushuo
//
//  Created by hans on 16/7/1.
//  Copyright © 2016年 汉斯哈哈哈. All rights reserved.
//

import UIKit

extension UIImage {

    class func imageWithColor(_ color: UIColor, size: CGSize) -> UIImage {
        
        let rect = CGRect(x: 0, y: 0, width: size.width == 0 ? 1.0 : size.width, height: size.height == 0 ? 1.0 : size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
     func resetImageSize(_ newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    

    
    func zjResizeToSize(_ size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    //根据颜色生成图片
    class func createImageWithColor(_ color : UIColor) -> UIImage {
        
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect);
        let theImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext();
        return theImage
    }
    
    func original() ->UIImage {
        
        return self.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
    }
    
    class func imageWithURL(_ url : String,imgView : UIImageView) -> UIImage {
        
        imgView.contentMode = UIViewContentMode.scaleAspectFit
        
        let request = URLRequest(url: URL(string: url)!)
        
        let thumbQueue = OperationQueue()
        
        var image : UIImage?
        
        NSURLConnection.sendAsynchronousRequest(request, queue: thumbQueue, completionHandler: { response, data, error in
            
            if (error != nil) {
                
                print(error)
                
            } else {
                
                DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async(execute: {
                    
                    image = UIImage(data: data!)
                    
                    DispatchQueue.main.async(execute: {
                        
                        return image
                    })
                })
                
            }
        })
        
        return image!
    }
}
