//
//  KeychainStore.swift
//  SugarKit
//
//  Created by Maksim Kolesnik on 19.04.2018.
//  Copyright © 2018 Sugar and Candy. All rights reserved.
//

import Foundation
import UIKit

public protocol KeychainRepresentable {
    @discardableResult func set(_ data: Data?, forKey key: String) -> Bool
    func data(forKey key: String) -> Data?
}

public class KeychainStore: KeychainRepresentable {
    
    public struct KeychainStoreConstants {
        public static var accessGroup: String { return toString(kSecAttrAccessGroup) }
        public static var accessible: String { return toString(kSecAttrAccessible) }
        public static var attrAccount: String { return toString(kSecAttrAccount) }
        public static var attrSynchronizable: String { return toString(kSecAttrSynchronizable) }
        public static var secClass: String { return toString(kSecClass) }
        public static var matchLimit: String { return toString(kSecMatchLimit) }
        public static var returnData: String { return toString(kSecReturnData) }
        public static var valueData: String { return toString(kSecValueData) }
        public static var generic: String { return toString(kSecAttrGeneric) }
        public static var service: String { return toString(kSecAttrService) }
        static func toString(_ value: CFString) -> String { return value as String }
    }
    public private(set) var service: String
    
    public init(service aService: String) {
        service = aService
    }

    @discardableResult public func set(_ data: Data?, forKey key: String) -> Bool {
        var status: OSStatus = OSStatus(0)
        var dict = query(forKey: key)
        if let aData = data {
            dict[KeychainStoreConstants.valueData] = data
            if let cahhedData = self.data(forKey: key), cahhedData != aData{
                status = SecItemUpdate((dict as CFDictionary), (dict as CFDictionary))
            } else {
                status = SecItemAdd((dict as CFDictionary), nil)
            }
        } else {
            status = SecItemDelete((dict as CFDictionary))
        }
        return (errSecSuccess == status)
        
    }
    
    public func update(_ data: Data, forKey key: String) -> Bool {
        let dictKey = query(forKey: key)
        var dictUpdate = [AnyHashable: Any]()
        dictUpdate[KeychainStoreConstants.valueData] = data
        let status = SecItemUpdate((dictKey as CFDictionary), (dictUpdate as CFDictionary))
        if status != errSecSuccess {
            Log.error("Unable add update with key =\(key) error:\(Int(status))")
        }
        return errSecSuccess == status
    }
    
    
    public func data(forKey key: String) -> Data? {
        var dict = query(forKey: key)
        dict[KeychainStoreConstants.matchLimit] = kSecMatchLimitOne
        dict[KeychainStoreConstants.returnData] = kCFBooleanTrue
        var result: AnyObject?
        let status = withUnsafeMutablePointer(to: &result) {
            SecItemCopyMatching(dict as CFDictionary, UnsafeMutablePointer($0))
        }
        if status != errSecSuccess {
            Log.error("Unable to fetch item for key \(key) with error:\(Int(status))")
            return nil
        }
        return result as? Data
    }
    
    public func query(forKey key: String) -> [String: Any] {
        let encodedKey = key.data(using: .utf8)
        var query = [String: Any]()
        query[KeychainStoreConstants.secClass] = kSecClassGenericPassword
        query[KeychainStoreConstants.generic] = encodedKey
        query[KeychainStoreConstants.attrAccount] = encodedKey
        query[KeychainStoreConstants.service] = service
        query[KeychainStoreConstants.accessible] = kSecAttrAccessibleAlwaysThisDeviceOnly
        return query
    }
}

extension KeychainStore {
    public func setDicitonary(_ data: [AnyHashable: Any], forKey key: String) -> Bool {
        let value = NSKeyedArchiver.archivedData(withRootObject: data)
        return self.set(value, forKey: key)
    }
    
    public func dictionary(forKey key: String) -> [AnyHashable: Any]? {
        guard let data = self.data(forKey: key) else { return nil }
        return NSKeyedUnarchiver.unarchiveObject(with: data) as? [AnyHashable: Any]
    }
    
    
}
