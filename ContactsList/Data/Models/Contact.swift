//
//  Contact.swift
//  ContactsList
//
//  Created by Elliott Walker on 09/04/2021.
//

import CoreData

@objc(Contact)
public class Contact: Entity {
    
    // MARK:- Variables
    
    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var email: String?
    @NSManaged public var phone: String?
    @NSManaged public var address: String?
    
    
    
}
