//
//  ContactServices.swift
//  Butler
//
//  Created by Brian on 5/20/17.
//  Copyright © 2017 LuomNguyen. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

class ContactServices : NSObject{
    
    //MARK: - Search contact on phone
    class func searchContactOnPhone(name : String, data: @escaping ((_ contacts :[CNContact]) -> Void)) {
        do {
            let predicate: NSPredicate = CNContact.predicateForContacts(matchingName: name)
            let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactBirthdayKey, CNContactViewController.descriptorForRequiredKeys()] as [Any]
            
            let contactStore = CNContactStore()
            let contactsTmp :[CNContact] = try contactStore.unifiedContacts(matching: predicate, keysToFetch:keysToFetch as! [CNKeyDescriptor])
            data(contactsTmp)
            
        } catch let error{
            print(error)
        }
    }
    
    //MARK: - save contact on phone
    class func saveContactOnPhone(isAdd: Bool?, contact : CNContact?, firstName: String?, lastName : String?, workPhone: String?, mobilePhone: String?, homePhone: String?, email : String?, street : String?, city : String?, region : String?, postCode : String?, birthday : DateComponents?, success: @escaping ((_ isSuccess: Bool) -> Void)) {
        print("saveContactOnPhone")
        do {
            let contactToUpdate : CNMutableContact
            if (contact?.mutableCopy() as? CNMutableContact) != nil {
                contactToUpdate = contact!.mutableCopy() as! CNMutableContact
            }else {
                contactToUpdate = CNMutableContact()
            }
            
            if homePhone != nil && homePhone != "" {
                contactToUpdate.phoneNumbers = [CNLabeledValue(label: CNLabelHome, value: CNPhoneNumber(stringValue: homePhone!))]
            }
            if workPhone != nil &&  workPhone != "" {
                contactToUpdate.phoneNumbers = [CNLabeledValue(label: CNLabelWork, value: CNPhoneNumber(stringValue: workPhone!))]
            }
            if mobilePhone != nil &&  mobilePhone != "" {
                contactToUpdate.phoneNumbers = [CNLabeledValue(label: CNLabelPhoneNumberMobile, value: CNPhoneNumber(stringValue: mobilePhone!))]
            }
            
            
            /* Test
             var birthday = DateComponents()
             birthday.year = 1991
             birthday.month = 1
             birthday.day = 1
             */
            contactToUpdate.birthday = birthday
            
            contactToUpdate.givenName = firstName!
            contactToUpdate.familyName = lastName!
            
            let homeAddress = CNMutablePostalAddress()
            homeAddress.street = street!
            homeAddress.city = city!
            homeAddress.state = region!
            homeAddress.postalCode = postCode!
            contactToUpdate.postalAddresses = [CNLabeledValue(label:CNLabelHome, value:homeAddress)]
            
            //Save contact
            let saveRequest = CNSaveRequest()
            if isAdd == true {
                saveRequest.add(contactToUpdate, toContainerWithIdentifier: nil)
            }else {
                saveRequest.update(contactToUpdate)
            }
            let contactStore = CNContactStore()
            try contactStore.execute(saveRequest)
            
            success(true)
            
        } catch let error{
            
            print(error)
            success(false)
        }
    }
    
}
