//
//  Log.swift
//  SugarKit
//
//  Created by Maksim Kolesnik on 19.04.2018.
//  Copyright © 2018 Sugar and Candy. All rights reserved.
//

import Foundation

public struct Log {
    public static func warning(_ string: String) {
        print("⚠️", string)
    }
    
    public static func error(_ string: String) {
        print("🛑", string)
    }

    public static func success(_ string: String) {
        print("✅", string)
    }
    
    public static func `default`(_ string: String) {
        print(string)
    }

}
