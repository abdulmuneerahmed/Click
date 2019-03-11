//
//  ViewController.swift
//  Click
//
//  Created by admin on 27/02/19.
//  Copyright © 2019 AcknoTech. All rights reserved.
//

import UIKit

class ClickTabBarVC: UITabBarController{

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        delegate = self
        setGradient()
        setup()
        
    }

    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        return .portrait
    }
    
    func setup(){
        let categoryVC = createControllers(vc: CategoryVC(), selectedImage: UIImage(named: "SCategory")!, tag: 0, title: "Category", unselectedImage: UIImage(named: "Category")!)
//
        let searchVC = createControllers(vc: SearchVC(), selectedImage:UIImage(named: "SSearch")!, tag: 1, title: "Search", unselectedImage: UIImage(named: "Search")!)
//
        let favoriteVC = createControllers(vc: MapSearchVC(), selectedImage: UIImage(named: "SMap")!, tag: 2, title: "MapSearch", unselectedImage: UIImage(named: "Map")!)
        

        
        viewControllers = [categoryVC,searchVC,favoriteVC]
        tabBar.barStyle = .default
        tabBar.selectedItem?.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor(white: 1, alpha: 1)], for: .selected)
    }
    
    func setGradient(){
        let gradientLayer = CAGradientLayer()
        let yellow = UIColor(red: 245/255, green: 175/255, blue: 25/255, alpha: 0.5)
        let orange = UIColor(red: 230/255, green: 92/255, blue: 0/255, alpha: 0.5)
        gradientLayer.colors = [yellow.cgColor,orange.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        self.tabBar.layer.addSublayer(gradientLayer)
    }
   
}

extension UITabBarController{
    
    func createControllers(vc:UIViewController,selectedImage:UIImage,tag:Int,title:String,unselectedImage:UIImage) -> UINavigationController{
        
        let viewController = vc
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem = UITabBarItem(title: title, image: unselectedImage, tag: tag)
        navController.tabBarItem.selectedImage = selectedImage
        navController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor(red: 121/255, green: 121/255, blue: 121/255, alpha: 1)], for: .normal)
        return navController
    }
}

extension ClickTabBarVC: UITabBarControllerDelegate{
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        tabBar.selectedItem?.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor(white: 1, alpha: 1)], for: .selected)
        return true
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
    }
    
    func getColoredImage(color:UIColor,size:CGSize) -> UIImage{
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
        UIGraphicsBeginImageContextWithOptions(size,false, 0)
        color.setFill()
        UIRectFill(rect)
        guard let image:UIImage = UIGraphicsGetImageFromCurrentImageContext() else{return UIImage()}
        UIGraphicsEndImageContext()
        return image
    }
}
