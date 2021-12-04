//
//  ErrorValet.swift
//  GKStorageKitTests
//
//  Created by Gligor Kotushevski on 20/03/17.
//  Copyright © 2017 Gligor Kotushevski. All rights reserved.
//

@testable import GKStorageKit

final class ErrorValet: SecureStorage {

    func canAccessKeychain() -> Bool {
        return false
    }

    func set(object: Data, forKey key: String) -> Bool {
        return false
    }

    func object(forKey key: String) -> Data? {
        return nil
    }

    func set(string: String, forKey key: String) -> Bool {
        return false
    }

    func string(forKey key: String) -> String? {
        return nil
    }

    func removeObject(forKey key: String) -> Bool {
        return false
    }

    func removeAllObjects() -> Bool {
        return false
    }

}
