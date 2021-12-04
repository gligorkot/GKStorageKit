//
//  SecureStorage.swift
//  GKStorageKit
//
//  Created by Gligor Kotushevski on 20/03/17.
//  Copyright © 2017 Gligor Kotushevski. All rights reserved.
//

import Foundation
import Valet

public protocol SecureStorage {
    func canAccessKeychain() -> Bool
    func setObject(_ object: Data, forKey key: String) throws
    func object(forKey key: String) throws -> Data
    func setString(_ string: String, forKey key: String) throws
    func string(forKey key: String) throws -> String
    func removeObject(forKey key: String) throws
    func removeAllObjects() throws
}

extension Valet: SecureStorage {}
