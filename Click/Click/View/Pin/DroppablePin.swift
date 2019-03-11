//
//  DroppablePin.swift
//  Click
//
//  Created by admin on 08/03/19.
//  Copyright © 2019 AcknoTech. All rights reserved.
//

import Foundation
import MapKit

class DroppablePin:NSObject,MKAnnotation{
    dynamic var coordinate: CLLocationCoordinate2D
    var identifier:String
    init (coordinate:CLLocationCoordinate2D,identifier:String){
        self.coordinate = coordinate
        self.identifier = identifier
    }
}
