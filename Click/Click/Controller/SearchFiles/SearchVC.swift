//
//  Categories.swift
//  Click
//
//  Created by admin on 27/02/19.
//  Copyright © 2019 AcknoTech. All rights reserved.
//

import UIKit
import Alamofire

class SearchVC:UIViewController,UISearchBarDelegate{
    
    
    
//   var imageUrlS
    override func loadView() {
        super.loadView()
        setup()
    }
    
    let reuseCell = "CellId"
    
    var imageUrlArray = [String]()
    var page:Int!
    var pages:Int!
//    var totally:Int!
    var searchString:String!
    var tempArrayCount:Int!
    
    var gradient:CAGradientLayer!
    
    let dataService = Data.instance
    let service = Service.instance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callRandomImageLoader()
        confiqureCollectionViewData()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        
    }
    
    lazy var photoView:CustomImageView = {
        let imageView = CustomImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .lightGray
        imageView.isHidden = true
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var blurEffectView:UIVisualEffectView  = {
        let blurEffectView = UIVisualEffectView()
        blurEffectView.effect = UIBlurEffect(style: .regular)
        blurEffectView.frame = view.frame
        return blurEffectView
    }()
    
    
    lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .vertical
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.isHidden = true
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = true
        return collectionView
    }()
    
    
    lazy var descriptionText:UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenirnext-Heavyitalic", size: view.frame.height/18)
        label.text = "Welcome"
        label.textColor = .white
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
//        label.backgroundColor = UIColor(white: 0, alpha: 0.3)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var spinner:UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.hidesWhenStopped = true
        spinner.style = .whiteLarge
        spinner.color = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
        spinner.isHidden = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    func setup(){
        
        navigationBarSetup()
        
        view.addSubview(photoView)
        let photoViewConstraits = [
            photoView.topAnchor.constraint(equalTo: view.topAnchor),
            photoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            photoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            photoView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(photoViewConstraits)
        view.addSubview(blurEffectView)
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        
        //Adding Blur effect
        
        addingSearchBar()
        
        
        blurEffectView.contentView.addSubview(descriptionText)
        NSLayoutConstraint.activate([
            descriptionText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionText.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            descriptionText.heightAnchor.constraint(equalToConstant: 50),
            descriptionText.widthAnchor.constraint(equalToConstant: view.frame.width - 30)
            ])
        addSpinner()
    }
    //navigationBarSetup
    func navigationBarSetup(){
        view.backgroundColor = .white
        navigationItem.title = "Search"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor(white: 1, alpha: 1),NSAttributedString.Key.font:UIFont(name: "Avenirnext-Heavyitalic", size: 20)!]
        //Large titles
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor(white: 1, alpha: 1),NSMutableAttributedString.Key.font:UIFont(name: "Avenirnext-Bold", size: 35)!]
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action:   nil)
        navigationItem.backBarButtonItem?.tintColor = .white
        
        //Setting
        setGradientNavBar()
    }
    
    func setGradientNavBar(){
        guard let navigationController = navigationController else{return}
        let flareGradientImage = CAGradientLayer.primaryGradient(on: navigationController.navigationBar)
        navigationController.navigationBar.barTintColor = UIColor(patternImage: flareGradientImage)
    }
    
    //AddingSearchBar
    func addingSearchBar(){
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Enter Text to Search"
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        searchController.searchBar.tintColor = .white
        searchController.searchBar.isTranslucent = false
        searchController.searchBar.barStyle = .default
        searchController.searchBar.searchBarStyle = .minimal
        

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        
    }
    
    func confiqureCollectionViewData(){
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SearchResultCell.self, forCellWithReuseIdentifier: reuseCell)
        registerForPreviewing(with: self, sourceView: collectionView)
        service.searchedImages.removeAll()
        collectionView.reloadData()
        
    }
    
    func callRandomImageLoader(){
        //Loades Images
        loadRandomImage(UrlString: dataService.unSplashImage(forApiKey: dataService.unsplash_API_Key)){ (finish,imageUrl) in
            if finish{
                self.photoView.loadImageUsingUrlString(urlString: imageUrl){
                    if $0{
                        
                    }else{
                        self.photoView.isHidden = true
                    }
                }
                self.photoView.isHidden = false
            }
        }
    }
    
    func addSpinner(){
        blurEffectView.contentView.addSubview(spinner)
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            spinner.heightAnchor.constraint(equalToConstant: 50),
            spinner.widthAnchor.constraint(equalToConstant: 50)
            ])
        
    }
    
    func loadRandomImage(UrlString url:String,handler: @escaping (_ status:Bool,_ urlString:String)->()){
        Alamofire.request(url).responseJSON { (response) in
            //print(response)
            guard let json = response.result.value as? Dictionary<String,AnyObject> else{return}
            
            let imageUrl = json["urls"] as? Dictionary<String,AnyObject>
            let imageStringUrl = imageUrl!["full"] as? String
            handler(true,imageStringUrl!)
        }
    }
    deinit {
        print("Search Vc os deinitilized")
    }
}

extension SearchVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return service.getSearchedImages().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseCell, for: indexPath) as? SearchResultCell else{return UICollectionViewCell()}
        cell.setImageToCell(imageString: service.getSearchedImages()[indexPath.item])
        //print(indexPath.item)
        loadMoreImages(indexPath: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let imageVC = PresentedImageVC()
        imageVC.hidesBottomBarWhenPushed = true
        let check = imageVC.setImage(urlString: service.getSearchedImages()[indexPath.item].imageName)
        
        if check{
            navigationController?.pushViewController(imageVC, animated: false)
        }
        
    }
    
}


extension SearchVC:UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        //
        guard let searchText = searchController.searchBar.text else{return}
        if searchText != ""{
            
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        descriptionText.isHidden = true
        imageUrlArray = []
        service.searchedImages.removeAll()
        collectionView.reloadData()
        
        guard let searchedText = searchBar.text else{return}
//        print(searchedText)
//        addSpinner()
        if searchedText != ""{
            
            searchString = searchedText.replacingOccurrences(of: " ", with: "+")
            spinner.startAnimating()
            searchImages(UrlString: dataService.flickerSearchUrl(urlApikey: dataService.flickerApi_Key, query: [searchString], safeMode: 3, pageNumber: nil, imagesPerPage: 400)){ (finish) in
                
                if finish && self.pages != 0{
                    
                    self.reloadImages()
                }else{
                    self.spinner.stopAnimating()
                    self.descriptionText.text = "🙁 No Image Found Try other..."
                    self.descriptionText.isHidden = false
                }
                
            }
        }
        
    }
    
    func reloadImages(){
        //print(imageUrlArray.count)
        tempArrayCount = imageUrlArray.count
        for imageString in imageUrlArray{
            service.searchedImages.append(SearchResultData(imageName: imageString))
        }
        collectionView.reloadData()
        spinner.stopAnimating()
        collectionView.isHidden = false
        
    }
}

extension SearchVC{
    
    func searchImages(UrlString url:String,handler: @escaping (_ status:Bool)->()){
    
        Alamofire.request(url).responseJSON { (response) in
            //print(response)
            guard let json = response.result.value as? Dictionary<String,AnyObject> else{return}
            let photosDict = json["photos"] as! Dictionary<String,AnyObject>
            let page = photosDict["page"] as! Int
            let pages = photosDict["pages"] as! Int
//            let total = photosDict["total"] as! Int
            let photosDictArray = photosDict["photo"] as! [Dictionary<String,AnyObject>]
            for photo in photosDictArray{
                let postUrl = "https://farm\(photo["farm"]!).staticflickr.com/\(photo["server"]!)/\(photo["id"]!)_\(photo["secret"]!)_h_d.jpg"
                self.imageUrlArray.append(postUrl)
                
            }
            
            self.page = page
            self.pages = pages
            handler(true)
        }
    }
    
}

//Load More
extension SearchVC{
    func loadMoreImages(indexPath:IndexPath){
        
        if (tempArrayCount - 1) == indexPath.item{
            //print("After $0")
            if page < pages && pages != 1{
                page += 1
                searchImages(UrlString: dataService.flickerSearchUrl(urlApikey: dataService.flickerApi_Key, query: [searchString], safeMode: 3, pageNumber: page, imagesPerPage: 400)){ (finish) in
                    
                    if finish{
                        self.appendNewItems()
                    }
                    
                }
            }
        }
    }
    
    func appendNewItems(){
        let tempArray = imageUrlArray[tempArrayCount...]
        for imageString in tempArray{
            service.searchedImages.append(SearchResultData(imageName: imageString))
        }
        
        collectionView.reloadData()
        tempArrayCount = imageUrlArray.count
    }
}



//Peek and POP

extension SearchVC:UIViewControllerPreviewingDelegate{
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = collectionView.indexPathForItem(at: location),let cell = collectionView.cellForItem(at: indexPath) else{return nil}
        
        let vc = PresentedImageVC()
        let check = vc.setImage(urlString:service.getSearchedImages()[indexPath.item].imageName)
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
