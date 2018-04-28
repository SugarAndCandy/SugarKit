//
//  EntityDescriptions.swift
//  Record
//
//  Created by Maksim Kolesnik on 27.04.2018.
//  Copyright © 2018 Sugar and Candy. All rights reserved.
//

import CoreData

    
public struct AnyEntityDescription<T: NSManagedObject> {
    
    var entityDescription: NSEntityDescription
    
    init(_ entityDescription: NSEntityDescription) {
        self.entityDescription = entityDescription
    }
    
    public var primaryKey: NSAttributeDescription? {
        guard let lookupKey = entityDescription.userInfo?[ImportingKeys.primaryKey] as? String else { return nil }
        return entityDescription.attributesByName[lookupKey]
    }
}

