//
//  Context.swift
//  Record
//
//  Created by Maksim Kolesnik on 20.04.2018.
//  Copyright © 2018 Sugar and Candy. All rights reserved.
//

import Foundation
import CoreData

class Context {
    
    static var main: Context {
        assert(initialized == nil, "Context is not setup")
        return initialized!
    }
    
    var main: NSManagedObjectContext
    var saving: NSManagedObjectContext
    
    init(main: NSManagedObjectContext, saving: NSManagedObjectContext) {
        self.main = main
        self.saving = saving
    }
    
    internal static var initialized: Context?
}
