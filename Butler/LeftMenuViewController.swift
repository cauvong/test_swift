//
//  LeftMenuViewController.swift
//  Butler
//
//  Created by Brian on 5/14/17.
//  Copyright © 2017 LuomNguyen. All rights reserved.
//

import UIKit

class LeftMenuViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let buttonLeftMenu = UIButton(type: .custom)
        buttonLeftMenu.setImage(#imageLiteral(resourceName: "ic_menu"), for: .normal)
        buttonLeftMenu.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        buttonLeftMenu.addTarget(self, action: #selector(tapMenuBarButton(_:)), for: .touchUpInside)
        let item = UIBarButtonItem(customView: buttonLeftMenu)
        self.navigationItem.setLeftBarButton(item, animated: true)
        
    }
    
    func tapMenuBarButton(_ sender: AnyObject) {
        
        
    }
}
