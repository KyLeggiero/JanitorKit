//
//  UserDefault.swift
//  JanitorKit
//
//  Created by Ben Leggiero on 7/19/19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import Foundation



@propertyWrapper
public struct UserDefault<Value> {
    let defaultValue: Value
    let key: String
    let userDefaults: UserDefaults

    init(initialValue: Value, _ key: String, userDefaults: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = initialValue
        self.userDefaults = userDefaults
    }

    public var wrappedValue: Value {
        get {
            return UserDefaults.standard.object(forKey: key) as? Value ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}
