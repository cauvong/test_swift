//
//  BaseViewController.swift
//  Butler
//
//  Created by Brian on 5/14/17.
//  Copyright © 2017 LuomNguyen. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        let view : UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: 215, height: 30))
        let imageView = UIImageView(image: #imageLiteral(resourceName: "ic_butler"))
        imageView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        view.addSubview(imageView)
        
        let lableTitle : UILabel = UILabel.init(frame: CGRect(x: 40, y: 0, width: 175, height: 30))
        lableTitle.text = "My Contact Butler"
        lableTitle.font = UIFont.boldSystemFont(ofSize: 20)
        lableTitle.textColor = UIColor.white
        view.addSubview(lableTitle)
        
        self.navigationItem.titleView = view
        
    }
    
//    //MARK: - Hide keyboard
//    func hideKeyboardWhenTappedAround() {
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
//        tap.cancelsTouchesInView = false
//        view.addGestureRecognizer(tap)
//    }
//    
//    func dismissKeyboard() {
//        view.endEditing(true)
//    }
    
    //MARK: - Show alert
    func showAlert(message: String) {
        
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    
}
