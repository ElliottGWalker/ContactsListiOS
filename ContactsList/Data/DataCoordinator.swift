//
//  DataCoordinator.swift
//  ContactsList
//
//  Created by Elliott Walker on 09/04/2021.
//

import Foundation
import CoreData



final class DataCoordinator: NSObject {
    
    // MARK: - Variables
    
    private static var coordinator: DataCoordinator?
    public var container : NSPersistentContainer
    
    public class var shared: DataCoordinator {
        get {
            coordinator = coordinator == nil ? DataCoordinator() : coordinator
            return coordinator!
        }
        
    }
    
    
    
    // MARK: - Initializer
    
    private override init() {
        container = NSPersistentContainer(name: "ContactsList")
        container.loadPersistentStores(completionHandler:{(_, error) in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        })
        
        super.init()
    }
    
    
    
    // MARK: - Actions
    
    static private var backgroundContext: NSManagedObjectContext?
    static func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
//        let context = DataCoordinator.backgroundContext ?? DataCoordinator.shared.container.newBackgroundContext()
//
//        DataCoordinator.backgroundContext = context
//        context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
//        block(context)
        DispatchQueue.main.async {
            let context = DataCoordinator.shared.container.viewContext
            context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
            block(context)
        }
    }
    
       
    static func performViewTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        let context = DataCoordinator.shared.container.viewContext
        context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        block(context)
    }
}

