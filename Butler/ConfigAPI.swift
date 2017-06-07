//
//  ConfigAPI.swift
//  Butler
//
//  Created by Brian on 5/14/17.
//  Copyright © 2017 LuomNguyen. All rights reserved.
//

import Foundation

let hosting : String = "http://contactblinkapi.azurewebsites.net"


/* POST - SIGN IN
 {
 "UserName": "string",
 "Password": "string",
 }
 */
let signInApiPost : String = "/api/Users/Authenticate"

/* POST - SIGN UP
 {
 "UserName": "string",
 "Password": "string",
 "FirstName": "string",
 "LastName": "string"
 }
 */
let signUnApiPost : String = "/api/Users"

/* POST - Contacts
 {
 "FirstName": "string",
 "MiddleName": "string",
 "LastName": "string",
 "MobilePhone": "string",
 "HomePhone": "string",
 "WorkPhone": "string",
 "Address1": "string",
 "Address2": "string",
 "City": "string",
 "State": "string",
 "Zip": "string",
 "Email": "string",
 "Twitter": "string",
 "Facebook": "string",
 "Linkedin": "string",
 "UserGuid": "string",
 "BirthDate": "2017-05-14T04:04:45.857Z",
 "IsAdd": true
 }
 */
let sendContactsPost : String = "/api/Contacts"

/* POST - Request
 {
"UserGuid": "string",
"ContactGuid": "string",
"ExpirationDate": "string"
}
 */
let sendRequestPost : String = "/api/Requests"

