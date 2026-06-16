//
//  CharacteristicValue.swift
//  HomePlus
//
//  Created by Brandon Thomas on 6/13/26.
//

import Foundation

enum CharacteristicValue {
    
    /// Convert a Double/Float/Int/Bool/NSNumber to Double;
    /// returns nil if another type is provided.
    static func double(_ value: Any?) -> Double? {
        switch value {
        case let value as Double:
            return value
        case let value as Float:
            return Double(value)
        case let value as Int:
            return Double(value)
        case let value as Bool:
            return value ? 1 : 0
        case let value as NSNumber:
            return value.doubleValue
        default:
            return nil
        }
    }
    
    /// Convert a Double/Float/Int/Bool/NSNumber to Int;
    /// returns nil if another type is provided / if conversion fails.
    /// Will truncate any decimals (will NOT round).
    static func int(_ value: Any?) -> Int? {
        // Use guard here to (a) gracefully handle failure;
        //  (b) make non-Optional for rest of scope
        guard let doubleValue = double(value) else { return nil }
        return Int(doubleValue)
    }
    
    /// Convert a Bool/Int/NSNumber to Bool;
    /// returns nil if another type is provided.
    static func bool(_ value: Any?) -> Bool? {
        switch value {
        case let value as Bool:
            return value
        case let value as Int:
            return value != 0
        case let value as NSNumber:
            return value.boolValue
        default:
            return nil
        }
    }
}
