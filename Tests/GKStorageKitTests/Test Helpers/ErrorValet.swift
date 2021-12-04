//
//  ErrorValet.swift
//  GKStorageKitTests
//
//  Created by Gligor Kotushevski on 20/03/17.
//  Copyright © 2017 Gligor Kotushevski. All rights reserved.
//

import Foundation
@testable import GKStorageKit

final class ErrorValet: SecureStorage {

    func canAccessKeychain() -> Bool {
        return false
    }

    func setObject(_ object: Data, forKey key: String) throws {
        throw "Some error"
    }

    func object(forKey key: String) throws -> Data {
        throw "Some error"
    }

    func setString(_ string: String, forKey key: String) throws {
        throw "Some error"
    }

    func string(forKey key: String) throws -> String {
        throw "Some error"
    }

    func removeObject(forKey key: String) throws {
        throw "Some error"
    }

    func removeAllObjects() throws {
        throw "Some error"
    }

}

extension String: Error {}
