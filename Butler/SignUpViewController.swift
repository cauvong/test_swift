//
//  SignUpViewController.swift
//  Butler
//
//  Created by Brian on 5/14/17.
//  Copyright © 2017 LuomNguyen. All rights reserved.
//

import UIKit
import Alamofire
import IJProgressView

class SignUpViewController: BaseViewController, UITextFieldDelegate {
    
    //MARK: Properties
    @IBOutlet weak var textFieldUsername: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var textFieldFirstName: UITextField!
    @IBOutlet weak var textFieldLastName: UITextField!
    @IBOutlet weak var viewScroll: UIView!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
    }
    
    //MARK: - Hide keyboard
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //MARK: - IBAction
    @IBAction func tapToSignUp(_ sender: AnyObject) {
        
        let username : String = textFieldUsername.text!.trimmingCharacters()
        let password : String = textFieldPassword.text!.trimmingCharacters()
        let firstname : String = textFieldFirstName.text!.trimmingCharacters()
        let lastname : String = textFieldLastName.text!.trimmingCharacters()
        
        if username.characters.count != 0 && password.characters.count != 0 && firstname.characters.count != 0 && lastname.characters.count != 0{
            
            self.callApiSignUp(username: username, password: password, firstname: firstname, lastname: lastname)
        }else {
            
            self.showAlert(message: messageFillInfo)
        }
        
    }
    
    //MARK: - Private method
    private func callApiSignUp (username: String, password: String, firstname: String, lastname: String) {
        
        let parameters: Parameters = [
            "UserName": username,
            "Password": password,
            "FirstName": firstname,
            "LastName": lastname
        ]
        
        IJProgressView.shared.showProgressView(self.view)
        Alamofire.request(hosting+signUnApiPost, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                
                IJProgressView.shared.hideProgressView()
                if let status = response.response?.statusCode {
                    switch(status){
                    case 200:
                    
                        if let guid = response.result.value as? String{
                            UserDefaultsManager.userGuid = guid
                            print(UserDefaultsManager.userGuid+" "+guid)
                        }
                        
                        UserDefaultsManager.firstName = firstname
                        UserDefaultsManager.lastName = lastname
                        
                        WorkFlow.changeLoginScreenToHomeScreen()
                        
                    case 401:
                        self.showAlert(message: messageSignUpFail)
                        
                    default:
                        print("The other statuscode.")
                        
                    }
                }
        }
        
    }
    
    //MARK: - UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("textFieldDidBeginEditing")
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            let rect = CGRect(x: 0, y: -100, width: self.viewScroll.frame.size.width, height: self.viewScroll.frame.size.height)
            self.viewScroll.frame = rect
        })
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        print("textFieldShouldEndEditing")
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            let rect = CGRect(x: 0, y: 0, width: self.viewScroll.frame.size.width, height: self.viewScroll.frame.size.height)
            self.viewScroll.frame = rect
        })
        return true
    }

    
}
