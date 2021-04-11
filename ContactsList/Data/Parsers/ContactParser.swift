//
//  ContactParser.swift
//  ContactsList
//
//  Created by Elliott Walker on 09/04/2021.
//

import Foundation
import CoreData

class ContactParser: EntityParser {
    
    // MARK: - Variables
    
    override var dataClass: Entity.Type {
        return Contact.self
    }
    
    
    // MARK: - CRUD
    
    override func update(_ entity: Entity, with json: JSONDictionary, context: NSManagedObjectContext) throws {
        guard let contact = entity as? Contact else {
            throw EntityParser.ParseError.unexpectedClass
        }
        
        contact.firstName = json[Parameters.firstName] as? String
        contact.lastName = json[Parameters.lastName] as? String
        contact.email = json[Parameters.email] as? String
        contact.phone = json[Parameters.phone] as? String
        contact.address = json[Parameters.address] as? String
        
        try super.update(contact, with: json, context: context)
    }
}

extension ContactParser {
    
    private enum Parameters {
        static let firstName = "name"
        static let lastName = "last_name"
        static let email = "company_email"
        static let phone = "contact_number"
        static let address = "address_line"
    }
    
}

