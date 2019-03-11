//
//  CategoriesCelldata.swift
//  Click
//
//  Created by admin on 01/03/19.
//  Copyright © 2019 AcknoTech. All rights reserved.
//

import UIKit

struct CategoriesData {
    private(set) public var title:String
    private(set) public var imageName:String
    
    init(title:String,imageName:String) {
        self.title = title
        self.imageName = imageName
    }
}



