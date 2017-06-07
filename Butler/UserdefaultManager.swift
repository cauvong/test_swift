//
//  UserdefaultManager.swift
//  Butler
//
//  Created by Brian on 5/14/17.
//  Copyright © 2017 LuomNguyen. All rights reserved.
//

import Foundation

class UserDefaultsManager : NSObject {
    
    private static let userGuidKey = "userGuidKey"
    private static let userFirstNameKey = "userFirstNameKey"
    private static let userLastNameKey = "userLastNameKey"
    
    static var userGuid: String {
        get {
            if let guid = UserDefaults.standard.string(forKey: userGuidKey) {
                return guid
            }
            return ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: userGuidKey)
        }
    }
    
    static var firstName: String {
        get {
            if let firstName = UserDefaults.standard.string(forKey: userFirstNameKey) {
                return firstName
            }
            return ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: userFirstNameKey)
        }
    }
    
    static var lastName: String {
        get {
            if let lastName = UserDefaults.standard.string(forKey: userLastNameKey) {
                return lastName
            }
            return ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: userLastNameKey)
        }
    }
    
}
