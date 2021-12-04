//
//  StorageKit.swift
//  GKStorageKit
//
//  Created by Gligor Kotushevski on 20/03/17.
//  Copyright © 2017 Gligor Kotushevski. All rights reserved.
//

import Foundation
import GKBaseKit

public protocol SecureStorageInterface {
    func storeString(_ string: String, forKey key: String, onSuccess: () -> (), onFail: FailureBlock)
    func getString(forKey key: String, onSuccess: (String?) -> (), onFail: FailureBlock)
    func storeObject<T: Codable>(_ value: T, forKey key: String, onSuccess: () -> (), onFail: FailureBlock)
    func getObject<T: Codable>(forKey key: String, onSuccess: (T?) -> (), onFail: FailureBlock)
    func removeValue(forKey key: String, onSuccess: () -> (), onFail: FailureBlock)
    func cleanStorage(onSuccess: () -> (), onFail: FailureBlock)
}

public protocol ObjectStorageInterface {
    func storeCollection<T: Codable>(_ collection: Array<T>, forKey key: String, onSuccess: () -> ())
    func getCollection<T: Codable>(forKey key: String, onSuccess: ([T]?) -> ())
    func storeObject<T: Codable>(_ value: T, forKey key: String, onSuccess: () -> ())
    func getObject<T: Codable>(forKey key: String, onSuccess: (T?) -> ())
    func removeValue(forKey key: String, onSuccess: () -> ())
    func cleanStorage(onSuccess: () -> ())
}

public protocol FileStorageInterface {
    func storeFile(_ fileData: Data, fileExtension: String, onSuccess: @escaping (URL) -> (), onFail: @escaping FailureBlock)
    func getFileStorageURL(fileExtension: String) -> URL
    func cleanStorage(onSuccess: @escaping () -> (), onFail: @escaping FailureBlock)
}

public final class StorageKit {

    private init() {} // noone should be able to init this class

    public class func initStorageKit(storage: StorageProtocol = DefaultStorage()) {
        let _ = StorageKit()
        StorageKitConfiguration.setup(with: EnvironmentConfiguration(storage: storage))
    }

    public class var secureStorage: SecureStorageInterface {
        return SecureStorageService(secureStorage: StorageKitConfiguration.shared.storage.secureStorage)
    }

    public class var objectStorage: ObjectStorageInterface {
        return ObjectStorageService(storage: StorageKitConfiguration.shared.storage.userDefaults)
    }

    public class var fileStorage: FileStorageInterface {
        return FileStorageService(documentsUrl: StorageKitConfiguration.shared.storage.fileStorageUrl)
    }

    /// clean up all storages here
    public class func cleanupStorages(onCompletion: @escaping () -> ()) {
        // clean up all storages concurrently
        let group = DispatchGroup()
        var error: ErrorResponse?

        group.enter()
        // clean secure storage
        secureStorage.cleanStorage(onSuccess: {
            group.leave()
        }) { err in
            error = err
            group.leave()
        }

        group.enter()
        // clean object storage
        objectStorage.cleanStorage(onSuccess: {
            group.leave()
        })

        group.enter()
        // clean file storage
        fileStorage.cleanStorage(onSuccess: {
            group.leave()
        }) { err in
            error = err
            group.leave()
        }

        // run completion block here
        group.notify(queue: DispatchQueue.global(qos: .default)) {
            if let _ = error {
                // ignore error for now, maybe log analytics here later on TODO
                onCompletion()
            } else {
                onCompletion()
            }
        }
    }

}
