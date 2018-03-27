//
//  Event.swift
//  Analytics
//
//  Created by MAXIM KOLESNIK on 26.03.2018.
//  Copyright © 2018 Sugar and Candy. All rights reserved.
//

import Foundation

public struct Event: RawRepresentable, Equatable, Hashable {
    public struct Name: RawRepresentable, Equatable, Hashable {
        public typealias RawValue = String
        public var rawValue: Event.RawValue
        public var hashValue: Int {
            return rawValue.hashValue
        }

        public init(_ aRawValue: Event.RawValue) {
            rawValue = aRawValue
        }

        public init(rawValue aRawValue: Event.RawValue) {
            rawValue = aRawValue
        }
    }
    
    public var hashValue: Int {
        return rawValue.hashValue
    }
    
    public typealias RawValue = String
    
    public init(_ aRawValue: Event.RawValue) {
        rawValue = aRawValue
    }
    public init(rawValue aRawValue: Event.RawValue) {
        rawValue = aRawValue
    }
    public var rawValue: Event.RawValue
}


