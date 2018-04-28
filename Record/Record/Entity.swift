//
//  Entity.swift
//  Sugar
//
//  Created by MAXIM KOLESNIK on 22.04.2018.
//  Copyright © 2018 Maksim Kolesnik. All rights reserved.
//

import CoreData


public struct Entity<T: NSManagedObject> {
    public let entity: T
    public init(_ entity: T) {
        self.entity = entity
    }
    
}

extension Entity {

    public func `in`(_ context: NSManagedObjectContext = Context.main.root) -> T? {
        if entity.objectID.isTemporaryID {
            do { try entity.managedObjectContext?.obtainPermanentIDs(for: [entity]) }
            catch {
                Log.log("Obtain permanent IDs for object: \(entity) in context: \(String(describing: entity.managedObjectContext)) caused an error: \(error)", prefix: .record, type: .error)
                return nil
            }
        }
        do { return try context.existingObject(with: entity.objectID) as? T }
        catch {
            Log.log("Entity \(entity) not found in context \(context). Error: \(error)", prefix: .record, type: .error)
            return nil
        }
    }
}


extension Entity {
    
    public static func create(in context: NSManagedObjectContext = Context.main.saving) -> T? {
        guard let entityDescription = EntityDescription<T>.entityDescription(in: context) else { return nil }
        return NSManagedObject(entity: entityDescription, insertInto: context) as? T
    }
    
    public static func create(from object: [AnyHashable: Any], in context: NSManagedObjectContext = Context.main.saving) -> T? {
        var managedObject: T?
        context.performAndWait {
            if let primaryKeyAttribute = EntityDescription<T>.primaryKey {
                if let primaryKey = object[AnyPropertyDescription(primaryKeyAttribute).mappedKey] {
                    let predicate = NSPredicate(format: "%K == %@", argumentArray: [primaryKeyAttribute.name, primaryKey])
                    managedObject = Request<T>.first(with: predicate, in: context)
                }
            }
            if managedObject == nil {
                if let entity = create(in: context) {
                    managedObject = entity
                    Importer<NSManagedObject>(entity).importValues(from: object, in: context)
                }
            }
        }
        return managedObject
    }
}

extension Entity {
    
    public func delete(in context: NSManagedObjectContext = Context.main.root) throws {
        do {
            let existingObject = try context.existingObject(with: entity.objectID)
            context.delete(existingObject)
        } catch {
            throw error
        }
    }

    public static func delete(with predicate: NSPredicate? = nil, from context: NSManagedObjectContext = Context.main.root) {
        let request = FetchRequest<T>(in: context, filtered: predicate).nsFetchRequest
        request.returnsObjectsAsFaults = true
        request.includesPropertyValues = false
        let objectsToDelete = Request<T>.executeFetchRequest(request, in: context)
        for object in objectsToDelete {
            context.delete(object)
        }
    }

}
