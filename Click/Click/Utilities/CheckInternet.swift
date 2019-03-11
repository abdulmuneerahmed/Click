//
//  CheckInternet.swift
//  Click
//
//  Created by admin on 05/03/19.
//  Copyright © 2019 AcknoTech. All rights reserved.
//

import Foundation
import Alamofire

class Connectivity{
    class var isConnectedToInternet:Bool{
        return NetworkReachabilityManager()!.isReachable
    }
}
