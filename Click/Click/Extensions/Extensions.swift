//
//  Extensions.swift
//  Click
//
//  Created by admin on 01/03/19.
//  Copyright © 2019 AcknoTech. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

//Extension For Image

let imageCache = NSCache<AnyObject, AnyObject>()

public class CustomImageView: UIImageView {
    
    var imageUrlString:String?
    
    func loadImageUsingUrlString(urlString: String,handler: @escaping (_ status:Bool)->()) {
        
        imageUrlString = urlString
        
//        let url = URL(string: urlString)!
        
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage{
            self.image = imageFromCache
            return
        }
        
        
        Alamofire.request(urlString).responseImage { (response) in
            guard let imageToCache = response.result.value else{return}
//            print(imageToCache)
            let test1 = UIImage(named: "unavailable")
            let test2 = UIImage(named: "unavailable2")
            
            if  test1 != imageToCache || test2 != imageToCache{
                
                if self.imageUrlString == urlString{
                    self.image = imageToCache
                }
                imageCache.setObject(imageToCache,forKey:urlString as AnyObject)
                handler(true)
            }else{
                 handler(false)
            }
           
            
        }
        
    }
    
}




extension CAGradientLayer{
    class func primaryGradient(on view:UIView) -> UIImage{
        let gradient = CAGradientLayer()
        let yellow = UIColor(red: 245/255, green: 175/255, blue: 25/255, alpha: 1)
        let orange = UIColor(red: 230/255, green: 92/255, blue: 0/255, alpha: 1)
        var bounds = view.bounds
        bounds.size.height += UIApplication.shared.statusBarFrame.size.height
        gradient.frame = bounds
        gradient.colors = [yellow.cgColor,orange.cgColor]
//        gradient.locations = [0.0,1.0]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 0)
        return gradient.createGradientImage(on:view)
    }
    
    func createGradientImage(on view:UIView) ->UIImage{
        var gradientImage:UIImage?
        UIGraphicsBeginImageContext(view.frame.size)
        if let context = UIGraphicsGetCurrentContext(){
            render(in: context)
            gradientImage = UIGraphicsGetImageFromCurrentImageContext()?.resizableImage(withCapInsets: .zero, resizingMode: .stretch)
        }
        UIGraphicsEndImageContext()
        guard let gradientimage = gradientImage else{return UIImage()}
        return gradientimage
    }
}
