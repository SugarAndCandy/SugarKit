//
//  AnyEntity.swift
//  Record
//
//  Created by Maksim Kolesnik on 28.04.2018.
//  Copyright © 2018 Sugar and Candy. All rights reserved.
//

import CoreData

public struct Importer<T> {
    public var entity: T
    public init(_ entity: T) {
        self.entity = entity
    }
}

fileprivate extension Request {
    func entity(for entityName: String, with predicate: NSPredicate, in context: NSManagedObjectContext) -> NSManagedObject? {
        var relatedObject: NSManagedObject?
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        fetchRequest.entity =  NSEntityDescription.entity(forEntityName: entityName, in: context)
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = predicate
       
        context.performAndWait {
            do {
                relatedObject = try context.fetch(fetchRequest).first
            } catch {
                relatedObject = nil
            }
        }
        
        if relatedObject == nil {
            if let entityDescription = NSEntityDescription.entity(forEntityName: entityName, in: context) {
                relatedObject = NSManagedObject(entity: entityDescription, insertInto: context)
            }
        }
        
        return relatedObject
    }
}

public extension Importer where T: NSManagedObject {
    
    public func importValues(from rootObject: [AnyHashable: Any], in context: NSManagedObjectContext) {
        importAttributes(from: rootObject)
        importRelationship(from: rootObject) { (relationship, object) in
            if let destinationEntity = relationship.destinationEntity {
                if let primaryKeyAttribute = AnyEntityDescription(destinationEntity).primaryKey {
                    if let primaryKey = object[AnyPropertyDescription(primaryKeyAttribute).mappedKey] {
                        print(destinationEntity.managedObjectClassName)
                        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: destinationEntity.managedObjectClassName)
                        fetchRequest.entity = destinationEntity
                        fetchRequest.fetchLimit = 1
                        fetchRequest.predicate = NSPredicate(format: "%K == %@", argumentArray: [primaryKeyAttribute.name, primaryKey])
                        do {
                            var relatedObject: NSManagedObject? = try context.fetch(fetchRequest).first
                            if relatedObject == nil {
                                if let entityDescription = NSEntityDescription.entity(forEntityName: destinationEntity.managedObjectClassName, in: context) {
                                    relatedObject = NSManagedObject(entity: entityDescription, insertInto: context)
                                }
                            }
                            if let entity = relatedObject {
                                let new = Importer<NSManagedObject>(entity)
                                new.importValues(from: object, in: context)
                                addObject(relatedObject, to: self.entity, toRelationship: relationship)
                                
                            }
                        } catch {
                            print(error)
                        }
                    }
                } else {
                    if  let entityDescription = NSEntityDescription.entity(forEntityName: destinationEntity.managedObjectClassName, in: context) {
                        let relatedObject: NSManagedObject? = NSManagedObject(entity: entityDescription, insertInto: context)
                        if let entity = relatedObject {
                            let new = Importer<NSManagedObject>(entity)
                            new.importValues(from: object, in: context)
                            addObject(relatedObject, to: self.entity, toRelationship: relationship)
                        }
                    }
                }
            }
        }
    }
    
    internal func addObject(_ object: NSManagedObject?, to root: NSManagedObject, toRelationship relationship: NSRelationshipDescription) {
        guard let object = object else { return }
        if relationship.isToMany {
            if let name = root.value(forKeyPath: relationship.name), name is NSOrderedSet && relationship.isOrdered {
                root.mutableOrderedSetValue(forKey: relationship.name).add(object)
            } else {
                if root.value(forKeyPath: relationship.name) is NSSet {
                    root.mutableSetValue(forKey: relationship.name).add(object)
                }
            }
        } else {
            root.setValue(object, forKey: relationship.name)
        }
    }
    
    internal func importRelationship(from object: [AnyHashable: Any], related: (NSRelationshipDescription, [AnyHashable: Any]) -> ()) {
        let relationships = entity.entity.relationshipsByName
        for relationship in relationships {
            let anyAttributeDescription = AnyPropertyDescription(relationship.value)
            let lookupKey = anyAttributeDescription.mappedKey
            if let value = object[lookupKey] {
                if let toManyValues = value as? [[AnyHashable: Any]], relationship.value.isToMany {
                    for singleRelatedValue in toManyValues {
                        related(relationship.value, singleRelatedValue)
                    }
                } else {
                    if let toOneValue = value as? [AnyHashable: Any], !relationship.value.isToMany {
                        related(relationship.value, toOneValue)
                    }
                }
            }
        }
    }
    
    internal func importAttributes(from object: [AnyHashable: Any]) {
        let attributes = entity.entity.attributesByName
        for attribute in attributes {
            let anyAttributeDescription = AnyPropertyDescription(attribute.value)
            let lookupKey = anyAttributeDescription.mappedKey
            if let value = anyAttributeDescription.value(forKeyPath: lookupKey, fromObjectData: object) {
                entity.setValue(value, forKey: attribute.key)
            } else {
                if let defaultValue = attribute.value.defaultValue {
                    entity.setValue(defaultValue, forKey: attribute.key)
                }
            }
        }
    }
    
}
