//
//  ContactsView.swift
//  Butler
//
//  Created by Brian on 5/20/17.
//  Copyright © 2017 LuomNguyen. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

protocol ContactsViewDelegate {
    func didPressButtonSend(firstname: String, lastname: String, phoneNumberOrEmail: String)
}

class ContactsView: UIView {
    
    //MARK: - Properties
    @IBOutlet weak var viewBackground : UIView!
    @IBOutlet weak var viewTableView : UIView!
    @IBOutlet weak var tableViewContact : UITableView!
    @IBOutlet weak var viewInformation : UIView!
    @IBOutlet weak var labelFirstname : UILabel!
    @IBOutlet weak var labelLastname : UILabel!
    @IBOutlet weak var labelPhoneNumber : UILabel!
    
    var contacts : [CNContact]?
    var delegate: ContactsViewDelegate!
    
    //MARK: - Class func
    class func instanceFromNib() -> UIView {
        return UINib(nibName:"ContactsView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    //MARK: - Life cycle
    
    override init(frame: CGRect){
        super.init(frame: frame)
        print("init view")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print("init coder")
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(gestureRecognizer:)))
        tap.cancelsTouchesInView = false
        self.viewBackground!.addGestureRecognizer(tap)
    }

    //MARK: - IBAction
    @IBAction func tapToAddContact (_ sender : AnyObject) {
        print("add")
        
        let firstname : String = self.labelFirstname.text!.trimmingCharacters()
        let lastname : String = self.labelLastname.text!.trimmingCharacters()
        let phoneNumberOrEmail : String = self.labelPhoneNumber.text!.trimmingCharacters()
        delegate.didPressButtonSend(firstname: firstname, lastname: lastname, phoneNumberOrEmail: phoneNumberOrEmail)
        setDisappearView()
    }
    
    //MARK: - Private methods

    func handleTap(gestureRecognizer: UIGestureRecognizer) {
        setDisappearView()
    }

    public func displayInformationView(contact : CNContact) {
       
        self.labelFirstname.text = contact.givenName
        self.labelLastname.text =  contact.familyName
        self.labelPhoneNumber.text = ((contact.phoneNumbers.first?.value)?.stringValue)!
        
        UIView.animate(withDuration: 0.3) {
            self.viewInformation.alpha = 1.0
            self.viewTableView.alpha = 0
        }
        
    }
    
    //MARK: - Public methods
    
    public func setVisibleView(contacts : [CNContact]?) {
        
        print("Im here:\(String(describing: contacts?.count))")
        
        self.contacts = contacts

        self.viewTableView.alpha = 1.0
        self.viewInformation.alpha = 0
        UIView.animate(withDuration: 0.3, animations: { 
            self.alpha = 1.0
        }, completion: { (Bool) in
            self.tableViewContact.reloadData()
        })
    }
    
    public func setDisappearView() {
        
        UIView.animate(withDuration: 0.3, animations: { 
            self.alpha = 0
        }, completion: { (Bool) in
//            self.removeFromSuperview()
        })
    }
    
}

//MARK: - Extention

extension ContactsView : UITableViewDelegate,UITableViewDataSource{
    
    public func numberOfSections(in tableView: UITableView) -> Int{
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        print("numberofrow:\(String(describing: contacts?.count))")
        guard self.contacts != nil else {
            return 0
        }
        return self.contacts!.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
            ?? UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        
        let contact : CNContact = contacts![indexPath.row] as CNContact
        cell.textLabel?.text = contact.givenName + " " + contact.familyName
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
        let contact : CNContact = contacts![indexPath.row] as CNContact
        displayInformationView(contact: contact)
    }
    
}
