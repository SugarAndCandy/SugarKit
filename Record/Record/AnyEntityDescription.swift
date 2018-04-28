//
//  EntityDescriptions.swift
//  Record
//
//  Created by Maksim Kolesnik on 27.04.2018.
//  Copyright © 2018 Sugar and Candy. All rights reserved.
//

import Foundation
import CoreData

public struct ImportingKeys {
    public static let primaryKey = "PrimaryKey"
    public static let mappedKey = "MappedKey"
}

public struct AnyEntityDescription<T: NSManagedObject>: EntityDescriber {
    
    public static var primaryKey: NSAttributeDescription? {
        guard let lookupKey = entityDescription?.userInfo?[ImportingKeys.primaryKey] as? String else { return nil }
        return entityDescription?.attributesByName[lookupKey]
    }
    
    
    
    public static var entityDescription: NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: AnyEntityNaming(T.self).entityName, in: Context.main.root)

    }
    
    public static func entityDescription(in context: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: AnyEntityNaming(T.self).entityName, in: context)
    }

}

public struct AnyAttributeDescription<T: NSAttributeDescription> {
    let attributeDescription: NSAttributeDescription
    init(_ attributeDescription: NSAttributeDescription) {
        self.attributeDescription = attributeDescription
    }
    
    public var mappedKey: String {
        guard let lookupKey = attributeDescription.userInfo?[ImportingKeys.mappedKey] as? String else { return attributeDescription.name }
        return lookupKey

    }
}
