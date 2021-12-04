//
//  SecureStorageService.swift
//  GKStorageKit
//
//  Created by Gligor Kotushevski on 20/03/17.
//  Copyright © 2017 Gligor Kotushevski. All rights reserved.
//

import Valet
import GKBaseKit

final class SecureStorageService: SecureStorageInterface {

    private var storage: SecureStorage

    init(secureStorage: SecureStorage) {
        self.storage = secureStorage
    }

    func storeString(_ string: String, forKey key: String, onSuccess: () -> (), onFail: FailureBlock) {
        let stored: Bool
        if !string.isEmpty {
            stored = storage.set(string: string, forKey: key)
        } else {
            stored = false
        }
        if stored {
            onSuccess()
        } else {
            let error: StorageError = .saveStringError(string, key)
            onFail(error.toResponse())
        }
    }

    func getString(forKey key: String, onSuccess: (String?) -> (), onFail: FailureBlock) {
        if !storage.canAccessKeychain() {
            let error: StorageError = .getError(key)
            onFail(error.toResponse())
        } else {
            onSuccess(storage.string(forKey: key))
        }
    }

    func removeValue(forKey key: String, onSuccess: () -> (), onFail: FailureBlock) {
        if !storage.canAccessKeychain() {
            let error: StorageError = .deleteError(key)
            onFail(error.toResponse())
        } else {
            let _ = storage.removeObject(forKey: key)
            onSuccess()
        }
    }

    func storeObject<T: Codable>(_ value: T, forKey key: String, onSuccess: () -> (), onFail: FailureBlock) {
        let stored = storage.set(object: try! JSONEncoder().encode(value), forKey: key)
        if stored {
            onSuccess()
        } else {
            let error: StorageError = .saveObjectError(value, key)
            onFail(error.toResponse())
        }
    }

    func getObject<T: Codable>(forKey key: String, onSuccess: (T?) -> (), onFail: FailureBlock) {
        if !storage.canAccessKeychain() {
            let error: StorageError = .getError(key)
            onFail(error.toResponse())
        } else {
            if let data = storage.object(forKey: key) {
                onSuccess(try? JSONDecoder().decode(T.self, from: data))
            } else {
                onSuccess(nil)
            }
        }
    }

    func cleanStorage(onSuccess: () -> (), onFail: FailureBlock) {
        if !storage.canAccessKeychain() {
            let error: StorageError = .cleanStorageError
            onFail(error.toResponse())
        } else {
            let _ = storage.removeAllObjects()
            onSuccess()
        }
    }

}
