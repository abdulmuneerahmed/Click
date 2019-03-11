//
//  RecentPhotosCell.swift
//  Click
//
//  Created by admin on 28/02/19.
//  Copyright © 2019 AcknoTech. All rights reserved.
//

import UIKit


class CategoryCell: UICollectionViewCell{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    lazy var backgroundImageView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        
        return view
    }()
    
    
    
    lazy var photoView:CustomImageView = {
        let imageView = CustomImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .lightGray
        
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var textLabel:UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Avenirnext-Heavyitalic", size: self.frame.size.height/18)
        label.adjustsFontSizeToFitWidth = true
        label.layer.cornerRadius = 12
        label.isHidden = true
        label.textAlignment = .center
        label.clipsToBounds = true
        label.backgroundColor = UIColor(white: 0, alpha: 0.3)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    func setup(){
        
        //Setting BackgroundView
        addSubview(backgroundImageView)
        
        let backgroundViewConstraints = [
            backgroundImageView.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            
        ]
        
        NSLayoutConstraint.activate(backgroundViewConstraints)
        
        backgroundImageView.layer.shadowOffset = CGSize(width: 5, height: 5)
        backgroundImageView.layer.shadowRadius = 8
        backgroundImageView.layer.shadowOpacity = 0.8
        backgroundImageView.layer.shadowColor = UIColor(red: 126/255, green: 126/255, blue: 126/255, alpha: 1).cgColor
        //Setting PhotoImageView
        backgroundImageView.addSubview(photoView)
        
        let photoViewConstraits = [
            photoView.topAnchor.constraint(equalTo: backgroundImageView.topAnchor),
            photoView.leadingAnchor.constraint(equalTo: backgroundImageView.leadingAnchor),
            photoView.trailingAnchor.constraint(equalTo: backgroundImageView.trailingAnchor),
            photoView.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor)
        ]
        NSLayoutConstraint.activate(photoViewConstraits)
        //        photoView.layer.addSublayer(gradient)
        
        backgroundImageView.addSubview(textLabel)
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: backgroundImageView.topAnchor),
            textLabel.leadingAnchor.constraint(equalTo: backgroundImageView.leadingAnchor),
            textLabel.trailingAnchor.constraint(equalTo: backgroundImageView.trailingAnchor),
            textLabel.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor)
            ])
    }
    
    
    
    
    
}



extension CategoryCell{
    func updateView(categories:CategoriesData){
        textLabel.text = categories.title
        photoView.loadImageUsingUrlString(urlString: categories.imageName){ (finish) in
            if finish{
                
            }else{
                self.backgroundImageView.isHidden = true
                self.photoView.isHidden = true
                self.textLabel.isHidden = true
            }
        }
        textLabel.isHidden = false
    }
}
