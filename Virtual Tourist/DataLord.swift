//
//  DataLord.swift
//  Virtual Tourist
//
//  Created by Derek Justus on 5/5/18.
//  Copyright © 2018 Derek Justus. All rights reserved.
//

import Foundation
import CoreData

class DataLord {
    
    let persistentContainer:NSPersistentContainer
    
    var viewContext:NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
     let bgContext:NSManagedObjectContext!
    
    init(modelName:String) {
        persistentContainer = NSPersistentContainer(name: modelName)
        
        bgContext = persistentContainer.newBackgroundContext()
    }
    
    func configureContexts() {
        viewContext.automaticallyMergesChangesFromParent = true
        bgContext.automaticallyMergesChangesFromParent = true
        
        bgContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
    }
    
    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { storeDescription, error in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }      
            self.configureContexts()
            completion?()
        }
    }
    
}
