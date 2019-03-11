//
//  HomeVC.swift
//  Click
//
//  Created by admin on 27/02/19.
//  Copyright © 2019 AcknoTech. All rights reserved.
//

import UIKit
import Alamofire

class CategoryVC:UIViewController{
    
    override func loadView() {
        super.loadView()
        setup()
        noConnectionSetup()
    }
    
    //DELEGATE
    
    //    var imgeUrlArray:[ImageData]?
    
    var imageUrlString:[String]?
    
    let service = Service.instance
    
    let urlsService = Data.instance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkConnection()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        cancelAllSession()
    }
    
    func checkConnection(){
        
        if Connectivity.isConnectedToInternet{
            collectionSource()
            
            loadCategories()
        }else{
            
            noConnectionView.isHidden = false
        }
        
    }
    
    let albumCell = "CellId"
    //Defining CollectionView
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
    
   

    
    //Setup Function For Views
    lazy var spinner:UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.hidesWhenStopped = true
        spinner.style = .whiteLarge
        spinner.color = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    

    lazy var noConnectionView:NoConnection = {
        let view = NoConnection()
//        view.backgroundColor = .blue
        view.delegate = self
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    func noConnectionSetup(){
        view.addSubview(noConnectionView)
        NSLayoutConstraint.activate([
            noConnectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            noConnectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            noConnectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            noConnectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
    }
    
    
    func setup(){

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
        
        
        view.backgroundColor = .white
        
        setupNavigationBar()

        setGradient()
    }
    
    
    func setupNavigationBar(){
        navigationItem.title = "Category"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor(white: 1, alpha: 1),NSAttributedString.Key.font:UIFont(name: "Avenirnext-Heavyitalic", size: 20)!]
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font:UIFont(name: "Avenirnext-Bold", size: 35)!,NSAttributedString.Key.foregroundColor:UIColor(white: 1, alpha: 1)]
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    //Settin delegate and data source
    func collectionSource(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: albumCell)
        spinner.startAnimating()
    }
    
    func setGradient(){
        guard let navigationController = navigationController else{return}
        let flareGradientImage = CAGradientLayer.primaryGradient(on: navigationController.navigationBar)
        navigationController.navigationBar.barTintColor = UIColor(patternImage: flareGradientImage)
    }
    
    func loadCategories(){
        let fashion = urlsService.pixabayUrl(urlApiKey: urlsService.pixabayApi_Key, query: ["Weather"])
//        let animals = urlsService.pixabayUrl(urlApiKey: urlsService.pixabayApi_Key, query: ["animals"])
        let birds = urlsService.pixabayUrl(urlApiKey: urlsService.pixabayApi_Key, query: ["birds"])
//        let sports = urlsService.pixabayUrl(urlApiKey: urlsService.pixabayApi_Key, query: ["sports"])
        let forest = urlsService.pixabayUrl(urlApiKey: urlsService.pixabayApi_Key, query: ["Forest"])
        let fruits = urlsService.pixabayUrl(urlApiKey: urlsService.pixabayApi_Key, query: ["Fruits"])
//        let home = urlsService.pixabayUrl(urlApiKey: urlsService.pixabayApi_Key, query: ["home"])
//        let sea = urlsService.pixabayUrl(urlApiKey: urlsService.pixabayApi_Key, query: ["sea"])
        let mountain = urlsService.pixabayUrl(urlApiKey: urlsService.pixabayApi_Key, query: ["mountains"])
        let nature = urlsService.pixabayUrl(urlApiKey: urlsService.pixabayApi_Key, query: ["Nature"])
        let food = urlsService.pixabayUrl(urlApiKey: urlsService.pixabayApi_Key, query: ["Food"])
//        let black = urlsService.pixabayUrl(urlApiKey: urlsService.pixabayApi_Key, query: ["black"])
//        let white = urlsService.pixabayUrl(urlApiKey: urlsService.pixabayApi_Key, query: ["white"])
        let furniture = urlsService.pixabayUrl(urlApiKey: urlsService.pixabayApi_Key, query: ["Furniture"])
//        let car = urlsService.pixabayUrl(urlApiKey: urlsService.pixabayApi_Key, query: ["car"])
//        let phones = urlsService.pixabayUrl(urlApiKey: urlsService.pixabayApi_Key, query: ["phones"])
//        let vehicals = urlsService.pixabayUrl(urlApiKey: urlsService.pixabayApi_Key, query: ["Vehicals"])
        let flowers = urlsService.pixabayUrl(urlApiKey: urlsService.pixabayApi_Key, query: ["Flowers"])
        let cats = urlsService.pixabayUrl(urlApiKey: urlsService.pixabayApi_Key, query: ["Cats"])
        let dogs = urlsService.pixabayUrl(urlApiKey: urlsService.pixabayApi_Key, query: ["Dogs"])
//        let colors = urlsService.pixabayUrl(urlApiKey: urlsService.pixabayApi_Key, query: ["colors"])
        
        categoryDownloader(urlString: [fashion,birds,forest,fruits,mountain,nature,food,furniture,flowers,cats,dogs]) { (finish,imageUrlsArray,titleText) in
            
            if finish{
                //                print(imageUrlsArray)
                self.appendUrls(imageUrlsArray,titleText)
                //                print("Finish")
            }
            
        }
    }
    
    
    func appendUrls(_ urlString:[String],_ titletext:[String]){
        //        guard let imgeUrls = urlString else{return}
        for (val,url) in urlString.enumerated(){
            for (index,text) in titletext.enumerated() where val == index{
                service.categories.append(CategoriesData(title: text, imageName: url))
            }
        }
        collectionView.reloadData()
        spinner.stopAnimating()
        collectionView.isHidden = false
    }
    
    deinit {
        print("Category Vc os deinitilized")
    }
}

extension CategoryVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return service.getCategories().count
    }
    
    //Cell For RoW
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: albumCell, for: indexPath) as? CategoryCell else{return UICollectionViewCell()}
        cell.updateView(categories: service.getCategories()[indexPath.item])
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let numberOfColumns:CGFloat = 1
        let width = collectionView.frame.size.width
        let xinsets:CGFloat = 10
        let cellSpacing:CGFloat = 5
        
        return CGSize(width: (width/numberOfColumns) - (xinsets + cellSpacing), height: (width/numberOfColumns) - (xinsets + cellSpacing + 40))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let searchVC = CategoriesSearchedVC()
        
        searchVC.searchText = service.getCategories()[indexPath.item].title
        //        UIView.animate(withDuration: 0.5) {
        //        searchVC.
        searchVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(searchVC, animated: false)
        //        }
        
        //        print(indexPath.item)
    }
    
}


extension CategoryVC{
    
    func categoryDownloader(urlString urls:[String],handler: @escaping (_ status:Bool,_ imageUrls:[String],_ titleText:[String])->()){
        var imageUrls = [String]()
        var tags = [String]()
        for url in urls{
            Alamofire.request(url).responseJSON { (response) in
               // print(response)
                guard let json = response.result.value as? Dictionary<String,AnyObject> else{return}
                let photosDictArray = json["hits"] as! [Dictionary<String,AnyObject>]
                let totalHits = photosDictArray.count
                let dictRandom = Int.random(in: 0..<totalHits)
                let url = photosDictArray[dictRandom]["largeImageURL"] as! String
                let tag = photosDictArray[dictRandom]["tags"] as! String
                imageUrls.append(url)
                tags.append(tag)
                //                self.imageUrlString?.append(url)
                if urls.count == imageUrls.count{
                    handler(true,imageUrls,tags)
                }
            }
            
        }
        
        
    }
    
    
    func cancelAllSession(){
        Alamofire.SessionManager.default.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, downloaddata) in
            sessionDataTask.forEach({ $0.cancel() })
            downloaddata.forEach({ $0.cancel() })
        }
    }
    
    
    
}


extension CategoryVC:NoConnectionDelegate{
    func handleRefreshButton(){
        print("Hello")
        if Connectivity.isConnectedToInternet{
            noConnectionView.isHidden = true
            collectionSource()
            loadCategories()
        }
    }
}
