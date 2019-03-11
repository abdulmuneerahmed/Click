//
//  Service.swift
//  Click
//
//  Created by admin on 28/02/19.
//  Copyright © 2019 AcknoTech. All rights reserved.
//

import UIKit

class Service{
    static let instance = Service()
    
     var categories = [CategoriesData]()
    
     var searchedImages = [SearchResultData]()
    
     var categorySearchedImages = [SearchResultData]()
    
    var mapimages = [SearchResultData]()
    
    func getCategories() -> [CategoriesData]{
        return categories
    }
    
    func getSearchedImages() -> [SearchResultData]{
        return searchedImages
    }
    
    func getCategorySearchedData()->[SearchResultData]{
        return categorySearchedImages
    }
    
    func getMapImages() -> [SearchResultData]{
        return mapimages
    }
}


