//
//  AppDelegate.swift
//  ContactsList
//
//  Created by Elliott Walker on 07/04/2021.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Backend Variables
    
    var window: UIWindow?
    var tabBarHeight: CGFloat = 0
    
    static var shared: AppDelegate {
        get {
            //WARNING: Don't call this getter before instantiation
            return UIApplication.shared.delegate as! AppDelegate
        }
    }
    
    static let datamodelName = "ContactsList"
    static let storeType = "sqlite"

    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: AppDelegate.datamodelName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    

    // MARK: - Application Lifecycle
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupBaseVC(animated: true, loggedIn: false)
        UIApplication.shared.statusBarStyle = .lightContent
        return true
    }
    
    private func setupBaseVC(animated: Bool, loggedIn: Bool, launchURL: URL? = nil) {
        OperationQueue.main.addOperation {
            let vc: UIViewController?
            
            if(loggedIn) {
                let storyboard = UIStoryboard(name: "Main", bundle: .main)
                vc = storyboard.instantiateInitialViewController()
            } else {
                vc = UIStoryboard(name: "Main", bundle: .main).instantiateInitialViewController()
            }
            
            guard animated, let window = self.window else {
                self.window?.rootViewController = vc
                self.window?.makeKeyAndVisible()
                return
            }

            window.rootViewController = vc
            window.makeKeyAndVisible()
            UIView.transition(with: window,
                              duration: 0.3,
                              options: .transitionCrossDissolve,
                              animations: nil,
                              completion: nil)
        }
    }

}

