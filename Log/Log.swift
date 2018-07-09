//
//  Log.swift
//  SugarKit
//
//  Created by Maksim Kolesnik on 19.04.2018.
//  Copyright © 2018 Sugar and Candy. All rights reserved.
//

import Foundation

public struct Log {
    
    public struct Prefix: RawRepresentable {
        public init(rawValue: String) {
            self.rawValue = rawValue
        }
        
        public var rawValue: String
        
        public typealias RawValue = String
        
        public static var log: Log.Prefix {
            return Log.Prefix(rawValue: "Log")
        }
    }
    
    public struct LogType: RawRepresentable {
        public init(rawValue: String) {
            self.rawValue = rawValue
        }
        
        public var rawValue: String
        
        public typealias RawValue = String
        
        public static var success: LogType {
            return LogType(rawValue: "✅")
        }
        
        public static var warning: LogType {
            return LogType(rawValue: "⚠️")
        }
        
        public static var error: LogType {
            return LogType(rawValue: "🛑")
        }
    }
    
    public static func warning(_ string: String) {
         Log.log(string, prefix: .log, type: .warning)
    }
    
    public static func error(_ string: String) {
        Log.log(string, prefix: .log, type: .error)
    }

    public static func success(_ string: String) {
        Log.log(string, prefix: .log, type: .success)
    }
    
    public static func `default`(_ string: String) {
        print(string)
    }

    public static func log(_ message: String, prefix: Log.Prefix, type: Log.LogType = .success) {
        
        print(type.rawValue, prefix.rawValue, message)
    }
    
}
