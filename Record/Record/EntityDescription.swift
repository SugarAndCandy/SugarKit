//
//  EntityDescription.swift
//  Record
//
//  Created by Maksim Kolesnik on 28.04.2018.
//  Copyright © 2018 Sugar and Candy. All rights reserved.
//

import CoreData

public class EntityDescription<Entity: NSManagedObject>: EntityDescriptionable {
    
    public static var primaryKey: NSAttributeDescription? {
        guard let lookupKey = entityDescription?.userInfo?[ImportingKeys.primaryKey] as? String else { return nil }
        return entityDescription?.attributesByName[lookupKey]
    }
    
    public static var entityDescription: NSEntityDescription? {
        if #available(iOS 10.0, *) {
            return Entity.entity()
        } else {
            return entityDescription(in: Context.main.root)
        }
        
    }
    
    public static func entityDescription(in context: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: AnyEntityNaming(Entity.self).entityName, in: context)
    }
    
}
