//
//  EntityDescriber.swift
//  Record
//
//  Created by Maksim Kolesnik on 27.04.2018.
//  Copyright © 2018 Sugar and Candy. All rights reserved.
//

import Foundation
import CoreData

public protocol EntityDescriber {
    static var entityDescription: NSEntityDescription? { get }
    static func entityDescription(in context: NSManagedObjectContext) -> NSEntityDescription?
}
