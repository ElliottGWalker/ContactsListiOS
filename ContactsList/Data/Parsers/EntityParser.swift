//
//  EntityParser.swift
//  ContactsList
//
//  Created by Elliott Walker on 09/04/2021.
//

import Foundation
import CoreData


class EntityParser {
    
    // MARK: - Enums
    
    enum ParseError: Error {
        case missingRequiredFields
        case unexpectedClass
        case invalidField
    }
    
    
    
    //MARK: Private Var

    private var entityName: String {
        return String(describing: dataClass)
    }
    
    
    private var entityDescription: NSEntityDescription {
        return dataClass.entity()
    }
    
    
    
    //MARK:- Overridable Vars
    
    /**
     * This variable should be overriden by subclasses so that the correct Entity is retrieved.
     */
    internal var dataClass: Entity.Type {
        return Entity.self
    }
    
    
    //MARK:- Base Functionality
    
    internal func fetchRequest() -> NSFetchRequest<Entity> {
        return NSFetchRequest<Entity>(entityName: entityName)
    }
    
    
    /**
     Returns either a new or existing Core Data entity from our Entity class tree.
     
     - Parameter JSON:
     Optional JSONDict to populate/update the object with.
     The existence and match of the 'id' field in this JSON is the basis on which an existing object is retrieved.
     
     - Parameter context:
     ManagedObjectContext to create/retrieve the object from
     */
    internal func entity(from json: JSONDictionary, inContext context: NSManagedObjectContext) -> Entity? {
        var entity: Entity?
                
        if let id = id(from: json) {
            entity = existingEntity(id: id, inContext: context)
        }
        
        if entity == nil {
            entity = newEntity(inContext: context)
        }
        
        return entity
    }
    
    
    internal func entities(from jsonArray: JSONArray, inContext context: NSManagedObjectContext) -> [Entity] {
        var entities = [Entity]()
        
        for json in jsonArray {
            if let entity = entity(from: json, inContext: context) {
                entities.append(entity)
            }
        }
        
        return entities
    }
    
    
    
    //MARK:- Entity Creation/Retrieval
    
    internal func newEntity(inContext context: NSManagedObjectContext) -> Entity? {
        let entity = NSManagedObject(entity: entityDescription, insertInto: context) as? Entity
        
        if entity != nil {
            entity!.id = -1
        }
        
        return entity
    }
    
    
    func existingEntity(id: Int64, inContext context: NSManagedObjectContext) -> Entity? {
        do {
            let request = fetchRequest()
            request.resultType = .managedObjectResultType
            request.predicate = NSPredicate(format: "id == %d", id)
            
            let fetchedResults = try context.fetch(request)
            
            if let fetchedEntity = fetchedResults.first {
                return fetchedEntity
            }
        }
        catch {
            print("Fetch single item failed \(error)")
        }
        
        return nil
    }
    
    
    //MARK:- Updating an Entity
    
    internal func update(_ entity: Entity, with json: JSONDictionary, context: NSManagedObjectContext) throws {
        guard let id = id(from: json) else {
            throw ParseError.missingRequiredFields
        }
        
        if let dateCreated = json[Parameters.dateCreated] as? String {
            entity.createdAt = SmarterDateFormatter(.laravel).date(from: dateCreated)
        }
        
        entity.id = id
    }

    
    //MARK:- Specific Value Retrieval
    
    func id(from json: JSONDictionary) -> Int64? {
        return json[Parameters.id] as? Int64
    }
}



//MARK:- JSON Parameters

extension EntityParser {
    
    private enum Parameters {
        static let id =             "id"
        static let dateCreated =    "created_at"
    }
    
}

