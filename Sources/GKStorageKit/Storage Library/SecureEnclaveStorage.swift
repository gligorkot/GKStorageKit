//
//  SecureEnclaveStorage.swift
//  GKStorageKit
//
//  Created by Crunchie on 1/04/25.
//  Copyright © 2025 Gligor Kotushevski. All rights reserved.
//

import Foundation
import Valet

public protocol SecureEnclaveStorage {
    func setString(_ string: String, forKey key: String) throws
    func string(forKey key: String, withPrompt userPrompt: String) throws -> String
    func removeObject(forKey key: String) throws
}

extension SecureEnclaveValet: SecureEnclaveStorage {}
