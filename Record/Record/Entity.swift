//
//  Entity.swift
//  Sugar
//
//  Created by MAXIM KOLESNIK on 22.04.2018.
//  Copyright © 2018 Maksim Kolesnik. All rights reserved.
//

import Foundation
import CoreData


public protocol EntityDescriptionsCreatable: class {
    static func entityDescription(in context: NSManagedObjectContext) -> NSEntityDescription?
}

public class EntityDescription<Entity: NSManagedObject>: EntityDescriptionsCreatable {
    
    public static func entityDescription(in context: NSManagedObjectContext) -> NSEntityDescription? {
        let forEntityName = AnyEntityNaming.init(objectType: Entity.self).entityName
        let entityDescription = NSEntityDescription.entity(forEntityName: forEntityName, in: context)
        return entityDescription
    }

}

public struct Entity<T: NSManagedObject> {
    public let entity: T
    public init(entity: T) {
        self.entity = entity
    }
    
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
    
    public static func create(in context: NSManagedObjectContext = Context.main.saving) -> T? {
        guard let entityDescription = EntityDescription<T>.entityDescription(in: context) else { return nil }
        return NSManagedObject(entity: entityDescription, insertInto: context) as? T
    }
}
