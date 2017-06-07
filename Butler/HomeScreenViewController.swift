//
//  HomeScreenViewController.swift
//  Butler
//
//  Created by Brian on 5/14/17.
//  Copyright © 2017 LuomNguyen. All rights reserved.
//

import UIKit
import Alamofire
import IJProgressView
import Contacts
import ContactsUI
import Toaster

class HomeScreenViewController: LeftMenuViewController, ContactsViewDelegate, UITextFieldDelegate {
    
    //MARK: Properties
    @IBOutlet weak var textFieldFirstName: UITextField!
    @IBOutlet weak var textFieldLastName: UITextField!
    @IBOutlet weak var textFieldPhoneNumberOrEmail: UITextField!
    @IBOutlet weak var textFieldSearchContact: UITextField!
    @IBOutlet weak var viewScroll: UIView!
    @IBOutlet weak var viewHideKeyboard: UIView!
    
    
    var viewContacts : ContactsView? = nil
    var countUpdateContacts : Int = 0
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let window :UIWindow = UIApplication.shared.keyWindow!
        viewContacts = ContactsView.instanceFromNib() as? ContactsView
        viewContacts?.delegate = self
        viewContacts?.alpha = 0
        viewContacts?.autoresizingMask = [.flexibleRightMargin, .flexibleLeftMargin, .flexibleBottomMargin, .flexibleTopMargin, .flexibleWidth, .flexibleHeight]
        viewContacts?.frame = self.view.bounds
        window.addSubview(viewContacts!)
        
        //Add notification keyboard
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
        
        hideKeyboardWhenTappedAround()
    }
    
    //MARK: - Hide keyboard
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.viewHideKeyboard.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    deinit {
//        NotificationCenter.default.removeObserver(self)
    }

    
    func keyboardWillShow(_ notification: Notification) {
//        
//        let info = notification.userInfo!
//        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            let rect = CGRect(x: 0, y: -170, width: self.viewScroll.frame.size.width, height: self.viewScroll.frame.size.height)
            self.viewScroll.frame = rect
        })
    }
    
    func keyboardWillHide(_ notification: Notification) {
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            let rect = CGRect(x: 0, y: 0, width: self.viewScroll.frame.size.width, height: self.viewScroll.frame.size.height)
            self.viewScroll.frame = rect
        })
    }
    
    //MARK: - IBAction
    @IBAction func tapToAddNewContact(_ sender: AnyObject) {
        
        let firstname : String = textFieldFirstName.text!.trimmingCharacters()
        let lastname : String = textFieldLastName.text!.trimmingCharacters()
        let phoneNumberOrEmail : String = textFieldPhoneNumberOrEmail.text!.trimmingCharacters()
        
        if firstname.characters.count != 0 && lastname.characters.count != 0 && phoneNumberOrEmail.characters.count != 0{
            
            callApiPostContact(isAdd: true,firstname: firstname, lastname: lastname, phoneNumberOrEmail: phoneNumberOrEmail)
            
        }else {
            
            self.showAlert(message: messageFillInfo)
        }
    }
    
    @IBAction func tapToAddNewContactOnPhone (_ sender: AnyObject) {
        
        let name = textFieldSearchContact.text!.trimmingCharacters()
        IJProgressView.shared.showProgressView(self.view)
        let concurrentQueue = DispatchQueue(label: "example.viwaofoo.com", attributes: .concurrent)
        concurrentQueue.sync {
            
            print("name: \(String(describing: name))")
            self.dismissKeyboard()
            
            ContactServices.searchContactOnPhone(name: name, data: { contacts in
                
                print("contacts: \(contacts)")
                DispatchQueue.main.async {
                    IJProgressView.shared.hideProgressView()
                    self.viewContacts?.setVisibleView(contacts: contacts)
                    
                }
            })
        }
        
    }
    
    @IBAction func tapToCheckUpdated (_ sender: AnyObject) {
        self.callApiGetUpdatedContacts()
    }
    
    //MARK: - UITextFieldDelegate
   
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("textFieldDidBeginEditing")
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            let rect = CGRect(x: 0, y: -170, width: self.viewScroll.frame.size.width, height: self.viewScroll.frame.size.height)
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
    
    //MARK: - ContactsViewDelegate
    
    func didPressButtonSend(firstname: String, lastname: String, phoneNumberOrEmail: String) {
        
        if firstname.characters.count != 0 && lastname.characters.count != 0 && phoneNumberOrEmail.characters.count != 0 {
            callApiPostContact(isAdd: false,firstname: firstname, lastname: lastname, phoneNumberOrEmail: phoneNumberOrEmail)
        }else {
            self.showAlert(message: messageFillInfo)
        }
    }
    
    //MARK: - Private methods
    
    private func sendMessage(requestID: String) {
        print("Message has sent with requestID: \(requestID).")
        Toast(text: messageHasSent + requestID, duration: Delay.long).show()
    }
    
    private func updateContactOnPhone(updatedContacts:[Dictionary<String,AnyObject>]) {
        
        guard updatedContacts.count != 0 else {
            return
        }
        let concurrentQueue = DispatchQueue(label: "example.viwaofoo.com", attributes: .concurrent)
        concurrentQueue.sync {
            for i in 0..<updatedContacts.count {
                let dic = updatedContacts[i] as Dictionary<String, AnyObject>
                //Parsers
                var isAdd = dic["IsAdd"] as? Bool
                let firstName = dic["FirstName"] as? String
                let lastName = dic["LastName"] as? String
                let workPhone = dic["WorkPhone"] as? String
                let mobilePhone = dic["MobilePhone"] as? String
                let homePhone = dic["HomePhone"] as? String
                let email = dic["Email"] as? String
                let street = dic["Address1"] as? String
                let city = dic["City"] as? String
                let region = dic["State"] as? String
                let postCode = dic["Zip"] as? String
                
                let stringBirthday = dic["BirthDate"] as? String
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                let date : Date = (dateFormatter.date(from: stringBirthday!))!
                let calendar = NSCalendar.current
                let birthday = calendar.dateComponents([.year, .month, .day], from: date)
                let requestID = dic["RequestGuid"] as? String
                
                print("concurrentQueue \(i)")
                
                ContactServices.searchContactOnPhone(name: firstName! + " " + lastName!, data: { contacts in
                    DispatchQueue.main.async {
                        print("DispatchQueue. main \(i) + \(firstName! + " " + lastName!)")
                        if contacts.count > 0 {
                            isAdd = false
                        }else {
                            isAdd = true
                        }
                        ContactServices.saveContactOnPhone(isAdd: isAdd, contact: contacts.first, firstName: firstName, lastName: lastName, workPhone: workPhone, mobilePhone: mobilePhone, homePhone: homePhone, email: email, street: street, city: city, region: region, postCode: postCode, birthday: birthday
                            ,success: { isSuccess in
                            if isSuccess {
                                self.callApiPostCloseRequest(requestGuid:requestID!)
                            }else {
                                print("update \(firstName! + " " + lastName!) Fail ")
                                Toast(text: "\(firstName! + " " + lastName!) has been updated fail.", duration: Delay.long).show()
                            }
                        })
                    }
                })
            }
        }
    }
    
    //MARK: - Call api
    
    //Call api get update contact
    private func callApiGetUpdatedContacts() {
        
        let url = hosting + "/api/Users/" + UserDefaultsManager.userGuid + "/UpdatedContacts"
        print(url)
        
        IJProgressView.shared.showProgressView(self.view)
        Alamofire.request(url)
            .responseJSON { response in

                print("Get update contact Successful)")
                
                IJProgressView.shared.hideProgressView()
                if let status = response.response?.statusCode {
                    switch(status){
                    case 200:
//                        print("Get update contact Successful: \(String(describing: response.result.value))")
                        if let updatedContacts = response.result.value as? [Dictionary<String,AnyObject>]{
                            if updatedContacts.count > 0 {
                                self.updateContactOnPhone(updatedContacts: updatedContacts)
                                self.countUpdateContacts = updatedContacts.count
                            }else {
                                Toast(text: "No contacts to update.", duration: Delay.long).show()
                            }
                        }else {
                            Toast(text: "No contacts to update.", duration: Delay.long).show()
                        }
                    case 401:
                        self.showAlert(message: messageRequestIDFail)
                    default:
                        print("The other statuscode.")
                    }
                }
        }
    }
    
    //Call api post contact
    private func callApiPostContact(isAdd: Bool,firstname: String, lastname: String, phoneNumberOrEmail: String) {
        
        var phoneNumber: String
//        var email : String
        if phoneNumberOrEmail.range(of:"@") != nil {
            phoneNumber = "string"
//            email = phoneNumberOrEmail
        }else {
            phoneNumber = phoneNumberOrEmail
//            email = "string"
        }
        
        let parameters: Parameters = [
            "FirstName": firstname,
            "LastName": lastname,
            "MobilePhone": phoneNumber,
            "UserGuid": UserDefaultsManager.userGuid,
            "BirthDate": "01/01/1900",
            "IsAdd": isAdd,
        ]
        
        IJProgressView.shared.showProgressView(self.view)
        Alamofire.request(hosting+sendContactsPost, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                
                IJProgressView.shared.hideProgressView()
                if let status = response.response?.statusCode {
                    switch(status){
                    case 200:
                        print("send contact Successful: \(String(describing: response.result.value))")
                        Toast(text: "Generate contact successful", duration: Delay.long).show()
                        
                        if let guid = response.result.value as? String{
                            print("guid + \(guid)")
                            self.callApiPostRequest(contactGuid: guid)
                        }
                        
                    case 401:
//                        self.showAlert(message: messageSendContactFail)
                        Toast(text: messageSendContactFail, duration: Delay.long).show()
                        
                    default:
                        print("The other statuscode.")
                        
                    }
                }
        }
    }
    
    //Call api post contact
    private func callApiPostRequest(contactGuid : String) {
        
        let parameters: Parameters = [
            "UserGuid": UserDefaultsManager.userGuid,
            "ContactGuid": contactGuid,
            "ExpirationDate": "2017-10-16T02:46:25.919Z"
            ]
        
        print(parameters)
        
        self.textFieldSearchContact.text = ""
        IJProgressView.shared.showProgressView(self.view)
        Alamofire.request(hosting+sendRequestPost, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                
                IJProgressView.shared.hideProgressView()
                if let status = response.response?.statusCode {
                    switch(status){
                    case 200:
                        print("Request contact Successful: \(String(describing: response.result.value))")
                        if let requestID = response.result.value as? String{
                            self.sendMessage(requestID: requestID)
                        }
                        self.textFieldFirstName.text = ""
                        self.textFieldLastName.text = ""
                        self.textFieldPhoneNumberOrEmail.text = ""

                    case 401:
                        self.showAlert(message: messageRequestIDFail)
                        
                    default:
                        print("The other statuscode.")
                        
                    }
                }
        }
    }
    
    //Call api post close request
    private func callApiPostCloseRequest(requestGuid : String) {
        struct CloseRequest {
            static var countUpdateSuccessful = 0
            static var countUpdateTotal = 0
        }
        IJProgressView.shared.showProgressView(self.view)
        Alamofire.request(hosting+"/api/Requests/"+requestGuid+"/CloseRequest", method: .post, parameters: nil, encoding: JSONEncoding.default)
            .responseJSON { response in
                
                IJProgressView.shared.hideProgressView()
                if let status = response.response?.statusCode {
                    switch(status){
                    case 200:
                        print("Close Request Successful: \(String(describing: response.result.value))")
                        CloseRequest.countUpdateSuccessful += 1
                    case 401:
                        self.showAlert(message: messageRequestIDFail)
                        
                    default:
                        print("The other statuscode.")
                        
                    }
                }
                CloseRequest.countUpdateTotal += 1
                
                if CloseRequest.countUpdateTotal == self.countUpdateContacts && CloseRequest.countUpdateTotal > 0 {
                    if CloseRequest.countUpdateSuccessful > 1 {
                        Toast(text: "\(CloseRequest.countUpdateSuccessful) contacts have been added or updated", duration: Delay.long).show()
                    }else {
                        Toast(text: "1 contact has been added or updated", duration: Delay.long).show()
                    }
                    
                    CloseRequest.countUpdateSuccessful = 0
                    CloseRequest.countUpdateTotal = 0
                }
        }
    }
    
}



