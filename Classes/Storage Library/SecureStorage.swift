//
//  SecureStorage.swift
//  GKStorageKit
//
//  Created by Gligor Kotushevski on 20/03/17.
//  Copyright © 2017 Gligor Kotushevski. All rights reserved.
//

import Valet

public protocol SecureStorage {
    func canAccessKeychain() -> Bool
    func set(object: Data, forKey key: String) -> Bool
    func object(forKey key: String) -> Data?
    func set(string: String, forKey key: String) -> Bool
    func string(forKey key: String) -> String?
    func removeObject(forKey key: String) -> Bool
    func removeAllObjects() -> Bool
}

extension Valet: SecureStorage {}
