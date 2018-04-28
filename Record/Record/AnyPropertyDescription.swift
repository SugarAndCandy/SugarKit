//
//  AnyPropertyDescription.swift
//  Record
//
//  Created by Maksim Kolesnik on 28.04.2018.
//  Copyright © 2018 Sugar and Candy. All rights reserved.
//

import CoreData

public struct AnyPropertyDescription<T: NSPropertyDescription> {
    let propertyDescription: T
    init(_ propertyDescription: T) {
        self.propertyDescription = propertyDescription
    }
    
    public var mappedKey: String {
        guard let lookupKey = propertyDescription.userInfo?[ImportingKeys.mappedKey] as? String else { return propertyDescription.name }
        return lookupKey
        
    }
}

private func number(from aString: String?) -> NSNumber? {
    guard let string = aString, let doubleValue = Double(string) else { return nil }
    return NSNumber(value: doubleValue)
}

extension AnyPropertyDescription where T: NSAttributeDescription {
    
    
    
    public func value(forKeyPath keyPath: String, fromObjectData objectData: [AnyHashable : Any]) -> Any? {
        let value: Any? = (objectData as AnyObject).value(forKeyPath: keyPath)
        let attributeType = propertyDescription.attributeType
        
        switch attributeType {
        case .integer16AttributeType,
             .integer32AttributeType,
             .integer64AttributeType,
             .doubleAttributeType,
             .decimalAttributeType,
             .floatAttributeType: return number(from: (value as AnyObject).description)
            
        case .stringAttributeType: return (value as AnyObject).description
        case .booleanAttributeType:
            if let boolValue: NSNumber = value as? NSNumber {
                return boolValue.boolValue
            }
        default: return value
            
        }
        return value
    }
}
