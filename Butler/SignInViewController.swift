//
//  SignInViewController.swift
//  Butler
//
//  Created by Brian on 5/14/17.
//  Copyright © 2017 LuomNguyen. All rights reserved.
//

import UIKit
import Alamofire
import IJProgressView

class SignInViewController: BaseViewController {
    
    //MARK: - Properties
    @IBOutlet weak var textFieldUsername: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaultsManager.userGuid.characters.count != 0 {
            WorkFlow.changeLoginScreenToHomeScreen()
        }
        
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
    @IBAction func tapToLogin(_ sender: AnyObject) {
        
        let username = textFieldUsername.text!.trimmingCharacters()
        let password : String = textFieldPassword.text!.trimmingCharacters()
        
        if username.characters.count != 0 && password.characters.count != 0 {
            callApiSignIn(username: username, password: password)
        }else {
            
            self.showAlert(message: messageFillInfo)
        }
    }
    
    //MARK: - Private method
    private func callApiSignIn (username: String, password: String) {
      
        let parameters: Parameters = [
            "UserName": username,
            "Password": password
        ]
        
        IJProgressView.shared.showProgressView(self.view)
        Alamofire.request(hosting+signInApiPost, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                
                IJProgressView.shared.hideProgressView()
                if let status = response.response?.statusCode {
                    switch(status){
                        case 200:
                            
                            if let dic = response.result.value as? Dictionary<String,AnyObject>{
                                print(dic)
                                if let guid = dic["Guid"] as? String{
                                    UserDefaultsManager.userGuid = guid
                                }
                                if let firstName = dic["FirstName"] as? String{
                                    UserDefaultsManager.firstName = firstName
                                }
                                if let lastName = dic["LastName"] as? String{
                                    UserDefaultsManager.lastName = lastName
                                }
                            }
                        
                            WorkFlow.changeLoginScreenToHomeScreen()
                        
                        case 401:
                            self.showAlert(message: messageLoginFail)
                        
                        default:
                            print("The other statuscode.")
                    }
                }
        }
        
    }
    
}
