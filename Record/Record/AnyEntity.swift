//
//  AnyEntity.swift
//  Bolts
//
//  Created by Maksim Kolesnik on 20.04.2018.
//

import Foundation
import CoreData

public struct AnyEntityNaming: EntityNaming {

    public var entityName: String {
        return NSStringFromClass(self.objectType).components(separatedBy: ".").last!
    }
    
    public let objectType: NSObject.Type
    public init(object: NSObject) {
        self.objectType = type(of: object)
    }
    
    public init(objectType: NSObject.Type) {
        self.objectType = objectType
    }
}
