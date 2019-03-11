//
//  PresentedImage.swift
//  Click
//
//  Created by admin on 03/03/19.
//  Copyright © 2019 AcknoTech. All rights reserved.
//

import UIKit

class PresentedImageVC:UIViewController{
    override func loadView() {
        super.loadView()
        setup()
        setUpNavBar()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
   
    lazy var imageView:UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    func setup(){
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        
    }
    
    func setUpNavBar(){
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareImage))
        navigationItem.rightBarButtonItem?.tintColor = .white
    }
    
    @objc func shareImage(){
        guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else{
            print("No Image Found")
            return
        }
        
        let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc,animated: true)
    }
    
    func setImage(urlString url:String)->Bool{
        
        if let imagefromCache = imageCache.object(forKey: url as AnyObject) as? UIImage{
            imageView.image = imagefromCache
            return true
        }else{
            return false
        }
        
    }
    
    
}
