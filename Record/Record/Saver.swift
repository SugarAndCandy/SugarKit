//
//  Saver.swift
//  Record
//
//  Created by Maksim Kolesnik on 28.04.2018.
//  Copyright © 2018 Sugar and Candy. All rights reserved.
//

import CoreData

public struct Saver<T> { }

public extension Saver where T: NSManagedObject {
    
    public static func saveEntities(onSerialQueue entities: [[AnyHashable: Any]],
                                    deleteUnmatched: Bool,
                                    completionOnMainThread : @escaping (_ mainThreadEntities: [T]) -> Void) {
        let entityTypeNSStringValue = NSStringFromClass(T.self)
        let fullPathQueue = "ru.savingQueue." + entityTypeNSStringValue
        let currentQueue = DispatchQueue(label: fullPathQueue)
        saveEntities(entities, deleteUnmatched: deleteUnmatched, in: currentQueue, completionOnMainThread: completionOnMainThread)
    }
    
    public static func saveEntities(_ entities: [[AnyHashable: Any]],
                                    deleteUnmatched: Bool,
                                    in queue: DispatchQueue,
                                    completionOnMainThread completion: @escaping (_ mainThreadEntities: [T]) -> Void) {
        var parsedEntities = [T]()
        Context.save(in: queue, savingBlock: { (context) in
            parsedEntities = self.parseDictionaries(entities, deleteUnmatched: deleteUnmatched, in: context)
        }, completionOnMainThread: {
            let predicate = NSPredicate(format: "self in %@", parsedEntities)
            let mainThreadEntities = Request<T>.all(with: predicate, in: Context.main.root)
            completion(mainThreadEntities)
            
        })
    }
    
    public static func parseDictionaries(_ dictionaries: [[AnyHashable: Any]], deleteUnmatched: Bool, in context: NSManagedObjectContext) -> [T] {
        var importedObjects: [T] = []
        for dictionary in dictionaries {
            if let object = Entity<T>.create(from: dictionary, in: context) {
                importedObjects.append(object)
            }
            
        }
        if !deleteUnmatched {
            return importedObjects
        }
        let allObjects = Request<T>.all
        var objectsToDelete = Set(allObjects)
        let importedObjectsSet = Set(importedObjects)
        objectsToDelete.subtract(importedObjectsSet)
        for objectToDelete in objectsToDelete {
            try? Entity(objectToDelete).delete(in: context)
        }
        
        
        return importedObjects
    }
}


