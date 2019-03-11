//
//  NoConnection.swift
//  Click
//
//  Created by admin on 06/03/19.
//  Copyright © 2019 AcknoTech. All rights reserved.
//

import UIKit


protocol NoConnectionDelegate {
    func handleRefreshButton()
}

class NoConnection:UIView{
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLostConectionView()
        setButtonShadow()
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var delegate:NoConnectionDelegate?
    
    
    lazy var wifiImage:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "no-signal")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var textlabel:UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir Next", size: 18)
        label.text = "No Internet Connection"
        label.textColor = .darkGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var refreshButton:UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 8
        button.setTitle("Refresh", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 0/255, green: 150/255, blue: 255/255, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(dismissView(sender:)), for: .touchUpInside)
        return button
    }()
    
    func setupLostConectionView(){

        
       addSubview(wifiImage)
        NSLayoutConstraint.activate([
            wifiImage.centerXAnchor.constraint(equalTo:centerXAnchor),
            wifiImage.centerYAnchor.constraint(equalTo: centerYAnchor,constant: -50),
            wifiImage.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/3),
            wifiImage.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1/3)
            ])
       addSubview(textlabel)
        NSLayoutConstraint.activate([
            textlabel.topAnchor.constraint(equalTo: wifiImage.bottomAnchor, constant: 20),
            textlabel.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.1),
            textlabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7),
            textlabel.centerXAnchor.constraint(equalTo: centerXAnchor)
            ])
        addSubview(refreshButton)
        NSLayoutConstraint.activate([
            refreshButton.topAnchor.constraint(equalTo: textlabel.bottomAnchor, constant: 10),
            refreshButton.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.13),
            refreshButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/3),
            refreshButton.centerXAnchor.constraint(lessThanOrEqualTo: centerXAnchor)
            ])
    }
    
    func setButtonShadow(){
        refreshButton.layer.shadowOffset = CGSize(width: 3, height: 3)
        refreshButton.layer.shadowRadius = 4
        refreshButton.layer.shadowColor = UIColor(red: 126/255, green: 126/255, blue: 126/255, alpha: 1).cgColor
        refreshButton.layer.shadowOpacity = 0.5
    }
    
    @objc func dismissView(sender:UIButton){
        animateView(viewToAnimate: sender)
            delegate?.handleRefreshButton()
        
    }
    
    fileprivate func animateView(viewToAnimate:UIView){
        
        UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            viewToAnimate.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
        }) { (_) in
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 2, options: .curveEaseInOut, animations: {
                viewToAnimate.transform = .identity
            }, completion: nil)
        }
        
    }
}
