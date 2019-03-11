//
//  SearchResultCell.swift
//  Click
//
//  Created by admin on 02/03/19.
//  Copyright © 2019 AcknoTech. All rights reserved.
//

import UIKit

class SearchResultCell:UICollectionViewCell{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var backgroundImageView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
//        view.isHidden = trues
        return view
    }()
    
    lazy var spinner:UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.hidesWhenStopped = true
        spinner.style = .whiteLarge
        spinner.color = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    lazy var photoView:CustomImageView = {
        let imageView = CustomImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .lightGray
//        imageView.isHidden = true
        imageView.clipsToBounds = true
        return imageView
    }()
    
    
    
    func setupCell(){
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
        
        addSubview(spinner)
        
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            spinner.heightAnchor.constraint(equalToConstant: 50),
            spinner.widthAnchor.constraint(equalToConstant: 50)
            ])
        spinner.startAnimating()
    }
    
    func setImageToCell(imageString searchedImage:SearchResultData){
        photoView.loadImageUsingUrlString(urlString: searchedImage.imageName){ (finish) in
            if finish{
                
            }else{
                self.photoView.isHidden = true
                self.backgroundImageView.isHidden = true
            }
        }
        spinner.stopAnimating()
    }
}
