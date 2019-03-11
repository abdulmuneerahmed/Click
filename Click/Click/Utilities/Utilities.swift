//
//  Utilities.swift
//  Click
//
//  Created by admin on 28/02/19.
//  Copyright © 2019 AcknoTech. All rights reserved.
//

import Foundation

struct Data{
    
    //Api Keys
    let flickerApi_Key = "5ae1048494963caec21c2fdcdbe88edf"
    
    let pixabayApi_Key = "11726893-c8c57f551beebf3407d1d646f"
    
    let unsplash_API_Key = "6276f615f94a70dcfc122dcf71e1302dd7e4f7ab15238969a1f9f97915a03f8f"
    
    static let instance = Data()
    
//    Functions
    //---------Pixabay----------//
    func pixabayUrl(urlApiKey apiKey:String,query queryArray:[String])->String{
        let query = convertArrayToString(queryArray: queryArray)
        let url = "https://pixabay.com/api/?key=\(apiKey)&q=\(query)&image_type=photo&pretty=true"
        //print(url)
        return url
    }
    
    //-----------Flicker-----------//
    
    
    func flickerSearchUrl(urlApikey apikey:String,query queryArray:[String],safeMode safe_search:Int,pageNumber page_no:Int?,imagesPerPage perPage:Int?)->String{
        let query = convertArrayToString(queryArray: queryArray)
        if let page = page_no, let pages = perPage {
            return "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apikey)&text=\(query)&safe_search=\(safe_search)&per_page=\(pages)&page=\(page)&format=json&nojsoncallback=1"
        }
        else if let pages = perPage{
            return "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apikey)&text=\(query)&safe_search=\(safe_search)&per_page=\(pages)&format=json&nojsoncallback=1"
        }
        else{
            return "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apikey)&text=\(query)&safe_search=\(safe_search)&format=json&nojsoncallback=1"
        }
        
    }
    
    func flickrUrl(forApiKey key:String,withAnnotation annotation:DroppablePin, andNumberOfPhotos number:Int)->String{
        let url = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(key)&lat=\(annotation.coordinate.latitude)&lon=\(annotation.coordinate.longitude)&radius=1&radius_units=mi&per_page=\(number)&format=json&nojsoncallback=1"
        
        return url
    }
    //---------Unsplash----------
    
    func unSplashImage(forApiKey apiKey:String)->String{
        return "https://api.unsplash.com/photos/random?client_id=\(apiKey)"
    }
    
    func convertArrayToString(queryArray:[String])->String{
        var query = ""
        if queryArray.count > 1{
            query = queryArray.joined(separator: "+")
            //print(query)
        }else{
            query = queryArray[0]
            //print(query)
        }
        return query
    }
    
}


// https://api.unsplash.com/photos/random?client_id=6276f615f94a70dcfc122dcf71e1302dd7e4f7ab15238969a1f9f97915a03f8f
