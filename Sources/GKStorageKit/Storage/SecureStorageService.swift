//
//  SecureStorageService.swift
//  GKStorageKit
//
//  Created by Gligor Kotushevski on 20/03/17.
//  Copyright © 2017 Gligor Kotushevski. All rights reserved.
//

import Foundation
import Valet
import GKBaseKit

final class SecureStorageService: SecureStorageInterface {

    private var storage: SecureStorage

    init(secureStorage: SecureStorage) {
        self.storage = secureStorage
    }

    func storeString(_ string: String, forKey key: String, onSuccess: () -> (), onFail: FailureBlock) {
        let stored: Bool
        do {
            try storage.setString(string, forKey: key)
            stored = true
        } catch let e {
            debugPrint(e)
            stored = false
        }
        guard stored else {
            let error: StorageError = .saveStringError(string, key)
            onFail(error.toResponse())
            return
        }
        onSuccess()
    }

    func getString(forKey key: String, onSuccess: (String?) -> (), onFail: FailureBlock) {
        guard storage.canAccessKeychain() else {
            let error: StorageError = .getError(key)
            onFail(error.toResponse())
            return
        }
        onSuccess(try? storage.string(forKey: key))
    }

    func removeValue(forKey key: String, onSuccess: () -> (), onFail: FailureBlock) {
        guard storage.canAccessKeychain() else {
            let error: StorageError = .deleteError(key)
            onFail(error.toResponse())
            return
        }
        try? storage.removeObject(forKey: key)
        onSuccess()
    }

    func storeObject<T: Codable>(_ value: T, forKey key: String, onSuccess: () -> (), onFail: FailureBlock) {
        let encodedObject = try! JSONEncoder().encode(value)
        let stored: Bool
        do {
            try storage.setObject(encodedObject, forKey: key)
            stored = true
        } catch {
            stored = false
        }
        guard stored else {
            let error: StorageError = .saveObjectError(value, key)
            onFail(error.toResponse())
            return
        }
        onSuccess()
    }

    func getObject<T: Codable>(forKey key: String, onSuccess: (T?) -> (), onFail: FailureBlock) {
        guard storage.canAccessKeychain() else {
            let error: StorageError = .getError(key)
            onFail(error.toResponse())
            return
        }
        guard let data = try? storage.object(forKey: key) else {
            onSuccess(nil)
            return
        }
        onSuccess(try? JSONDecoder().decode(T.self, from: data))
    }

    func cleanStorage(onSuccess: () -> (), onFail: FailureBlock) {
        guard storage.canAccessKeychain() else {
            let error: StorageError = .cleanStorageError
            onFail(error.toResponse())
            return
        }
        try? storage.removeAllObjects()
        onSuccess()
    }

}
