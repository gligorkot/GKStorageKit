//
//  SecureEnclaveStorageService.swift
//  ForsythBarrKit
//
//  Created by Crunchie on 28/03/2025.
//  Copyright © 2025 Gligor Kotushevski. All rights reserved.
//

import GKBaseKit
import Valet

final class SecureEnclaveStorageService: SecureEnclaveStorageInterface {

    private var storage: SecureEnclaveStorage

    init(secureEnclaveStorage: SecureEnclaveStorage) {
        self.storage = secureEnclaveStorage
    }
    
    func storeSecret(_ secret: String, key: String) async throws {
        do {
            try storage.setString(secret, forKey: key)
        } catch {
            debugPrint(error)
            throw error
        }
    }
    
    func getSecret(key: String, prompt: String) async throws -> String {
        do {
            return try storage.string(forKey: key, withPrompt: prompt)
        } catch {
            debugPrint(error)
            throw error
        }
    }
    
    func deleteSecret(key: String) async throws {
        do {
            try storage.removeObject(forKey: key)
        } catch {
            debugPrint(error)
            throw error
        }
    }
    
    func cleanStorage() async throws {
        do {
            try storage.removeAllObjects()
        } catch {
            debugPrint(error)
            throw error
        }
    }
}

