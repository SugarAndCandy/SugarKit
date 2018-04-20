//
//  Log.swift
//  SugarKit
//
//  Created by Maksim Kolesnik on 19.04.2018.
//  Copyright © 2018 Sugar and Candy. All rights reserved.
//

import Foundation

struct Log {
    
    struct Prefix: RawRepresentable {
        init(rawValue: String) {
            self.rawValue = rawValue
        }
        
        var rawValue: String
        
        typealias RawValue = String
        
        static var log: Log.Prefix {
            return Log.Prefix(rawValue: "Log")
        }
    }
    
    struct LogType: RawRepresentable {
        init(rawValue: String) {
            self.rawValue = rawValue
        }
        
        var rawValue: String
        
        typealias RawValue = String
        
        static var success: LogType {
            return LogType(rawValue: "✅")
        }
        
        static var warning: LogType {
            return LogType(rawValue: "⚠️")
        }
        
        static var error: LogType {
            return LogType(rawValue: "🛑")
        }
    }
    
    static func warning(_ string: String) {
         Log.log(string, prefix: .log, type: .warning)
    }
    
    static func error(_ string: String) {
        Log.log(string, prefix: .log, type: .error)
    }

    static func success(_ string: String) {
        Log.log(string, prefix: .log, type: .success)
    }
    
    static func `default`(_ string: String) {
        print(string)
    }

    static func log(_ message: String, prefix: Log.Prefix, type: Log.LogType = .success) {
        
        print(type.rawValue, prefix.rawValue, message)
    }
    
}
