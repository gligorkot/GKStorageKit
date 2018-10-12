//
//  StorageProtocol.swift
//  GKStorageKit
//
//  Created by Gligor Kotushevski on 20/03/17.
//  Copyright © 2017 Gligor Kotushevski. All rights reserved.
//

public protocol StorageProtocol {
    var storageIdentifier: String { get }
    var secureStorage: SecureStorage { get }
    var userDefaults: UserDefaults { get }
    var fileStorageUrl: URL { get }
}
