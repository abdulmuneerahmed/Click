//
//  Favourite.swift
//  Click
//
//  Created by admin on 27/02/19.
//  Copyright © 2019 AcknoTech. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Alamofire

class MapSearchVC:UIViewController,UIGestureRecognizerDelegate{
    
    //Location Service Variable
    let reuseCell = "CellId"
    
    //Location Based Variable
    var locationManager = CLLocationManager()
    let authorizationStatus = CLLocationManager.authorizationStatus()
    let region:Double = 10000
    
    //Url Array
    var imageUrlArray = [String]()
    
    //singleTon Variable
    let service = Service.instance
    let dataService = Data.instance
    
    //Anchors
    var hiddenViewHightAnchor:NSLayoutConstraint!
    var buttonBottomToViewAnchor:NSLayoutConstraint!
    var buttonBottomToHiddenViewAnchor:NSLayoutConstraint!
    var collectionViewTopAnchor:NSLayoutConstraint!
    
    override func loadView() {
        super.loadView()
        setup()
        navBarSetup()
        addDoubleTap()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configurationLocationServices()
        collectionSetup()
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        return .portrait
    }
    
    func navBarSetup(){
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "MapSearch"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor(white: 1, alpha: 1),NSAttributedString.Key.font:UIFont(name: "Avenirnext-Heavyitalic", size: 20)!]
        
        //Large title Setup
        
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font:UIFont(name: "Avenirnext-Bold", size: 35)!,
            NSAttributedString.Key.foregroundColor:UIColor(white: 1, alpha: 1)]
        
        //Gradient Setup
        setGradientNavBar()
        
    }
    
    
    func setGradientNavBar(){
        guard let navigationController = navigationController else{return}
        let flareGradientImage = CAGradientLayer.primaryGradient(on: navigationController.navigationBar)
        navigationController.navigationBar.barTintColor = UIColor(patternImage: flareGradientImage)
    }
    
    lazy var mapView:MKMapView = {
        let mapview = MKMapView()
        mapview.isScrollEnabled = true
        mapview.showsBuildings = true
        mapview.showsUserLocation = true
        mapview.showsPointsOfInterest = true
        mapview.delegate = self
        mapview.showsTraffic = true
        mapview.showsCompass = true
        mapview.translatesAutoresizingMaskIntoConstraints = false
        return mapview
    }()
    
    lazy var hiddenView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var spinner:UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.hidesWhenStopped = true
        spinner.style = .whiteLarge
        spinner.color = .orange
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    lazy var currentLocationButton:UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "locationButton"), for: .normal)
        button.addTarget(self, action: #selector(currentLocationButtonAction), for: .touchUpInside)
        return button
    }()
    
    lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .vertical
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isHidden = true
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = true
        return collectionView
    }()
    
    func setup(){
        //Adding MapView
        view.addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
        
        //adding hidden View
        view.addSubview(hiddenView)
        
        NSLayoutConstraint.activate([
            hiddenView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            hiddenView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            hiddenView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
            ])
        
        hiddenViewHightAnchor = hiddenView.heightAnchor.constraint(equalToConstant: 0)
        hiddenViewHightAnchor.isActive = true
        
        //Adding Location Button
        view.addSubview(currentLocationButton)
        NSLayoutConstraint.activate([
            currentLocationButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            currentLocationButton.widthAnchor.constraint(equalToConstant: view.frame.width/5),
            currentLocationButton.heightAnchor.constraint(equalToConstant: view.frame.width/5)
            ])
        buttonBottomToViewAnchor = currentLocationButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        buttonBottomToViewAnchor.isActive = true
        buttonBottomToHiddenViewAnchor = currentLocationButton.bottomAnchor.constraint(equalTo: hiddenView.topAnchor)
        
        //Adding CollectionView to HiddenView
        hiddenView.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: hiddenView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: hiddenView.trailingAnchor),
            
            collectionView.bottomAnchor.constraint(equalTo: hiddenView.bottomAnchor)
            ])
        collectionViewTopAnchor = collectionView.topAnchor.constraint(equalTo: hiddenView.topAnchor)
        collectionViewTopAnchor.isActive = true
    }
    
    
    //Adding Swipe Gesture To HiddenView
    
    func addSwipeGesture(){
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(dismissSwipe))
        swipe.direction = .down
        hiddenView.addGestureRecognizer(swipe)
    }
    
    
    //Spinner Setup
    func addSpinner(){
        hiddenView.addSubview(spinner)
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: hiddenView.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: hiddenView.centerYAnchor),
            spinner.heightAnchor.constraint(equalToConstant: 50),
            spinner.widthAnchor.constraint(equalToConstant: 50)
            ])
        spinner.startAnimating()
    }
    
    func displayHiddenView(){
        buttonBottomToViewAnchor.isActive = false
        buttonBottomToHiddenViewAnchor.isActive = true
        UIView.animate(withDuration: 0.5) {
             self.hiddenViewHightAnchor.constant = self.view.frame.height/2 - 60
            self.view.layoutIfNeeded()
        }
        collectionViewTopAnchor.constant = 10
    }
    
//        MARK:- Selectors
    @objc func currentLocationButtonAction(){
//        let queue = DispatchQueue(label: "center-location")
        if authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse{
           
            DispatchQueue.main.async {
                self.centerUserMapLocation()
            }
            
        }
    }
    
    
    @objc func dismissSwipe(){
        cancelAllSession()
        buttonBottomToViewAnchor.isActive = true
        UIView.animate(withDuration: 0.5) {
             self.hiddenViewHightAnchor.constant = 0
            self.view.layoutIfNeeded()
        }
//        collectionViewTopAnchor.constant = 0
    }
    
    
    func collectionSetup(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SearchResultCell.self, forCellWithReuseIdentifier: reuseCell)
        registerForPreviewing(with: self, sourceView: collectionView)
    }
    
//    Adding Tap Gesture to mapView
    
    func addDoubleTap(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(droppablePin(sender:)))
        tap.delegate = self
        tap.numberOfTapsRequired = 1
        mapView.addGestureRecognizer(tap)
    }
    
    

//    Mark:- Location Setup
    
    func configurationLocationServices(){
        if CLLocationManager.locationServicesEnabled(){
            setupLocationManager()
            checkLocationAuthorization()
        }
    }
    
    
    func setupLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
    }
    
    func checkLocationAuthorization(){
        
        switch CLLocationManager.authorizationStatus(){
        case .authorizedAlways:
            locationServices()
            centerUserMapLocation()
            locationManager.startUpdatingLocation()
        case .authorizedWhenInUse:
            locationServices()
            centerUserMapLocation()
            locationManager.startUpdatingLocation()
        case .denied:
            //show alert instructing them how to turn on permissions
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            //show alert instructing them how to turn on permissions
            break
        }
    }
    
    func locationServices(){
        mapView.showsUserLocation = true
        
        locationManager.startUpdatingLocation()
    }
    
    //By using This Function It Centers The User Location
    func centerUserMapLocation(){
        
        guard let coordinate = locationManager.location?.coordinate else{return}
        let coordinateRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: region, longitudinalMeters: region)
        mapView.setRegion(coordinateRegion, animated: true)
    }
//    -------------------------------END LocationServices----------------------//
}



extension MapSearchVC: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}


extension MapSearchVC:MKMapViewDelegate{
    
    
    //MARK:- Selector
    
    //Creating Droppable Pin
    
    @objc func droppablePin(sender:UITapGestureRecognizer){
        utilitiesForPin()
        let touchPoint = sender.location(in: mapView)
        
        let touchCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        let annotation = DroppablePin(coordinate: touchCoordinate, identifier: "droppablePin")
        mapView.addAnnotation(annotation)
        

        let coordinateRegion = MKCoordinateRegion(center: touchCoordinate, latitudinalMeters: region, longitudinalMeters: region)
        mapView.setRegion(coordinateRegion, animated: true)
        
        retriveImageUrls(forAnnotaion: annotation) { (finish) in
            if finish{
                //print(self.imageUrlArray)
                self.spinner.stopAnimating()
                self.collectionView.isHidden = false
                self.reloadData()
                
            }
        }
    }
    
    func reloadData(){
        for imageString in imageUrlArray{
            service.mapimages.append(SearchResultData(imageName: imageString))
        }
//        print(service.)
        collectionView.reloadData()
    }
    
    func utilitiesForPin(){
        removeAnnotation()
        cancelAllSession()
        collectionView.isHidden = true
        displayHiddenView()
        addSpinner()
        addSwipeGesture()
        imageUrlArray = []
        service.mapimages.removeAll()
        collectionView.reloadData()
    }
    
    
    
    
    //Removing extra Annotations Pins
    func removeAnnotation(){
        for annotaion in mapView.annotations{
            mapView.removeAnnotation(annotaion)
        }
    }
    
    //Annotation
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{
            return nil
        }
        let pinAnnotation = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "droppablePin")
        pinAnnotation.pinTintColor = .orange
        pinAnnotation.animatesDrop = true
        return pinAnnotation
    }
    
}


extension MapSearchVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
 
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let numberOfColumns:CGFloat = 4
        let width = collectionView.frame.size.width
        let xinsets:CGFloat = 10
        let cellSpacing:CGFloat = 5
        
        return CGSize(width: (width/numberOfColumns) - (xinsets + cellSpacing), height: (width/numberOfColumns) - (xinsets + cellSpacing))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return service.getMapImages().count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseCell, for: indexPath) as? SearchResultCell else{return UICollectionViewCell()}
        cell.setImageToCell(imageString: service.getMapImages()[indexPath.item])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = PresentedImageVC()
        vc.hidesBottomBarWhenPushed = true
        let check = vc.setImage(urlString: service.getMapImages()[indexPath.item].imageName)
        if check{
            navigationController?.pushViewController(vc, animated: false)
        }
    }
}

extension MapSearchVC{
    
    //Getting Data From Flickr Api
    
    func retriveImageUrls(forAnnotaion annotation:DroppablePin,handler: @escaping (_ status:Bool)->()){
        
        Alamofire.request(dataService.flickrUrl(forApiKey: dataService.flickerApi_Key, withAnnotation: annotation, andNumberOfPhotos: 400)).responseJSON { (response) in
            guard let json = response.result.value as? Dictionary<String,AnyObject> else{return}
            let photosDict = json["photos"] as! Dictionary<String,AnyObject>
            let photosDictArray = photosDict["photo"] as! [Dictionary<String,AnyObject>]
            for photo in photosDictArray{
                let postUrl = "https://farm\(photo["farm"]!).staticflickr.com/\(photo["server"]!)/\(photo["id"]!)_\(photo["secret"]!)_h_d.jpg"
                self.imageUrlArray.append(postUrl)
            }
            handler(true)
        }
        
    }
    
    //CanCel All Downloade sesions
    
    func cancelAllSession(){
        Alamofire.SessionManager.default.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, downloaddata) in
            sessionDataTask.forEach({ $0.cancel() })
            downloaddata.forEach({ $0.cancel() })
        }
    }
}


extension MapSearchVC: UIViewControllerPreviewingDelegate{
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = collectionView.indexPathForItem(at: location), let cell = collectionView.cellForItem(at: indexPath) else{return nil}
        let vc = PresentedImageVC()
        let check = vc.setImage(urlString: service.getMapImages()[indexPath.item].imageName)
        if check {
            previewingContext.sourceRect = cell.contentView.frame
            vc.hidesBottomBarWhenPushed = true
            return vc
        }else{
            return nil
        }
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: self)
    }

    
}
