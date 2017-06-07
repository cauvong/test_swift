//
//  WorkFlow.swift
//  Butler
//
//  Created by Brian on 5/15/17.
//  Copyright © 2017 LuomNguyen. All rights reserved.
//

import UIKit

class WorkFlow {
    
    class func changeLoginScreenToHomeScreen() {
    
        let mainStoryboard: UIStoryboard = UIStoryboard(name:"Main", bundle: nil)
        let homeNaviController = mainStoryboard.instantiateViewController(withIdentifier: "HomeNaviController")
        UIApplication.shared.keyWindow?.rootViewController = homeNaviController
        UIApplication.shared.keyWindow?.makeKeyAndVisible()
    }
    
}
