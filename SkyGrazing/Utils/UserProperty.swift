//
//  UserProperty.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/05/20.
//

import Foundation

@propertyWrapper
public struct UserProperty<Value> {
    let key: String
    let defaultValue: Value
    let store: UserDefaults
    
    init(_ key: String, defaultValue: Value, store: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.store = store
    }

    public var wrappedValue: Value {
        get { store.object(forKey: key) as? Value ?? defaultValue }
        nonmutating set { store.set(newValue, forKey: key) }
    }
}

enum UserSettings {
    
    @UserProperty<String>("handle", defaultValue: "")
    static var handle: String
}
