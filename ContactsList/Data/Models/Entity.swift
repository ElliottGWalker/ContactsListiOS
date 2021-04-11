//
//  Entity.swift
//  ContactsList
//
//  Created by Elliott Walker on 09/04/2021.
//

import Foundation
import CoreData

@objc(Entity)
public class Entity: NSManagedObject {
    var entityName: String {
        return NSStringFromClass(type(of: self)).components(separatedBy: ".").last!
    }
    
    @NSManaged public var createdAt: Date?
    @NSManaged public var id: Int64
}
