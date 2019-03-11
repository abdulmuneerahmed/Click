//
//  SearchVC.swift
//  Click
//
//  Created by admin on 02/03/19.
//  Copyright © 2019 AcknoTech. All rights reserved.
//

import UIKit
import Alamofire

class CategoriesSearchedVC:UIViewController{

    let searchCell = "CellId"
    
    let service = Service.instance
    let urlsService = Data.instance
    var searchText:String?
    var stringUrlsArrays = [String]()
    var imageUrlArray = [String]()
    
    override func loadView() {
        super.loadView()
        setupView()
        setupNavBar()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewData()
        
        stringToArray()
        loadImages()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        collectionView.reloadData()

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        cancelAllSession()
//        service.categorySearchedImages.removeAll()
    }
    
    lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .vertical
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .white
        collectionView.isHidden = true
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = true
        return collectionView
    }()
    
    lazy var spinner:UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.hidesWhenStopped = true
        spinner.style = .whiteLarge
        spinner.color = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    func setupNavBar(){
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .white
    }
    
    func setupView(){
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
        
        view.addSubview(spinner)
        
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            spinner.heightAnchor.constraint(equalToConstant: 50),
            spinner.widthAnchor.constraint(equalToConstant: 50)
            ])
        spinner.startAnimating()
    }
    
    func collectionViewData(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SearchResultCell.self, forCellWithReuseIdentifier: searchCell)
        service.categorySearchedImages.removeAll()
        collectionView.reloadData()
        registerForPreviewing(with: self, sourceView: collectionView)
    }
    
    func stringToArray(){
        guard let searchText = searchText else{return}
        let searchStringArray = searchText.components(separatedBy: ", ")
        for searchString in searchStringArray{
            if !searchString.contains("girl") || !searchString.contains("woman"){
                let search = searchString.replacingOccurrences(of: " ", with: "+")
                stringUrlsArrays.append(urlsService.flickerSearchUrl(urlApikey: urlsService.flickerApi_Key, query: [search], safeMode: 3, pageNumber: nil, imagesPerPage: 400))
            }
            
        }
        
    }
    
    func loadImages(){
            flickerSearch(urlString: stringUrlsArrays) { (finish) in
                if finish{
//                    print("--------Finish-------")
//                    print(self.imageUrlArray.count)
                    self.reloadImages()
                }
                
            }
    }
    
    func reloadImages(){
//        service.searchedImages.removeAll()
        for imageString in imageUrlArray{
            service.categorySearchedImages.append(SearchResultData(imageName: imageString))
        }
        collectionView.reloadData()
        spinner.stopAnimating()
        collectionView.isHidden = false
    }
    deinit {
        print("CategoriesSearched Vc os deinitilized")
    }
}


extension CategoriesSearchedVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return service.getCategorySearchedData().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: searchCell, for: indexPath) as? SearchResultCell else{return UICollectionViewCell()}
        cell.setImageToCell(imageString: service.getCategorySearchedData()[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let numberOfColumns:CGFloat = 2
        let width = collectionView.frame.size.width
        let xinsets:CGFloat = 10
        let cellSpacing:CGFloat = 5
        
        return CGSize(width: (width/numberOfColumns) - (xinsets + cellSpacing), height: (width/numberOfColumns) - (xinsets + cellSpacing))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imageVC = PresentedImageVC()
        let check = imageVC.setImage(urlString: service.getCategorySearchedData()[indexPath.item].imageName)
        if check{
            navigationController?.pushViewController(imageVC, animated: false)
//            present(imageVC,animated: true,completion: nil)
        }
        
    }
    
}



extension CategoriesSearchedVC{
    
    func flickerSearch(urlString urls:[String],handler: @escaping(_ status:Bool)->()){
        imageUrlArray = []
        var count:Int = 0
        for url in urls{
//            let urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            Alamofire.request(url).responseJSON { (response) in
//                print(response)
                guard let json = response.result.value as? Dictionary<String,AnyObject> else{return}
                let photosDict = json["photos"] as! Dictionary<String,AnyObject>
                let photosDictArray = photosDict["photo"] as! [Dictionary<String,AnyObject>]
                for photo in photosDictArray{
                    let postUrl = "https://farm\(photo["farm"]!).staticflickr.com/\(photo["server"]!)/\(photo["id"]!)_\(photo["secret"]!)_h_d.jpg"
                    self.imageUrlArray.append(postUrl)
                }
                count += 1
                
                if urls.count == count{
                    handler(true)
                }
                
            }
        }
        
    }
    
    
    
    //Cancel Downloads
    //CanCel All Downloade sesions
    
    func cancelAllSession(){
        Alamofire.SessionManager.default.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, downloaddata) in
            sessionDataTask.forEach({ $0.cancel() })
            downloaddata.forEach({ $0.cancel() })
        }
    }
    
    
    
}


//Peek and POP

extension CategoriesSearchedVC:UIViewControllerPreviewingDelegate{
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = collectionView.indexPathForItem(at: location),let cell = collectionView.cellForItem(at: indexPath) else{return nil}
        
        let vc = PresentedImageVC()
        let check = vc.setImage(urlString:service.getCategorySearchedData()[indexPath.item].imageName)
        vc.hidesBottomBarWhenPushed = true
        if check {
            previewingContext.sourceRect = cell.contentView.frame
            return vc
        }
        else{
            return nil
        }
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: self)
    }
    
    
}
