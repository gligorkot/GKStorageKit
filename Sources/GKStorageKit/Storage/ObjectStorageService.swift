//
//  ObjectStorageService.swift
//  GKStorageKit
//
//  Created by Gligor Kotushevski on 20/03/17.
//  Copyright © 2017 Gligor Kotushevski. All rights reserved.
//

import Foundation
import GKBaseKit

final class ObjectStorageService: ObjectStorageInterface, StorageKitDecorator {

    private var objectStorage: UserDefaults

    init(storage: UserDefaults) {
        self.objectStorage = storage
    }

    func storeCollection<T: Codable>(_ collection: Array<T>, forKey key: String, onSuccess: () -> ()) {
        objectStorage.set(collection.map({ try? JSONEncoder().encode($0) }), forKey: key)
        onSuccess()
    }

    func getCollection<T: Codable>(forKey key: String, onSuccess: ([T]?) -> ()) {
        if let dataArray = objectStorage.value(forKey: key) as? [Data] {
            onSuccess(dataArray.map({ try! JSONDecoder().decode(T.self, from: $0) }))
        } else {
            onSuccess(nil)
        }
    }

    func storeObject<T: Codable>(_ value: T, forKey key: String, onSuccess: () -> ()) {
        objectStorage.set(try? JSONEncoder().encode(value), forKey: key)
        onSuccess()
    }

    func getObject<T: Codable>(forKey key: String, onSuccess: (T?) -> ()) {
        if let data = objectStorage.value(forKey: key) as? Data {
            onSuccess(try? JSONDecoder().decode(T.self, from: data))
        } else {
            onSuccess(nil)
        }
    }
    
    func storePerishableObject<T: Codable>(_ value: T, forKey key: String, onSuccess: () -> ()) {
        let storableTimestampItem = StorableTimestampItem<T>(timestamp: Date().timeIntervalSince1970, item: value)
        storeObject(storableTimestampItem, forKey: key, onSuccess: onSuccess)
    }
    
    func getPerishableObject<T: Codable>(expireAfter timeInterval: TimeInterval = 60, forKey key: String, onSuccess: (T) -> (), expired: () -> ()) {
        getObject(forKey: key) { (storable: StorableTimestampItem<T>?) in
            if let storable = storable, storable.timestamp + timeInterval > Date().timeIntervalSince1970 {
                // if cached exists and timestamp is not older than 60 seconds, return item
                onSuccess(storable.item)
            } else {
                expired()
            }
        }
    }
    
    func storePerishableCollection<T: Codable>(_ collection: Array<T>, forKey key: String, onSuccess: () -> ()) {
        let storableTimestampCollection = StorableTimestampCollection<T>(timestamp: Date().timeIntervalSince1970, collection: collection)
        storeObject(storableTimestampCollection, forKey: key, onSuccess: onSuccess)
    }
    
    func getPerishableCollection<T: Codable>(expireAfter timeInterval: TimeInterval = 60, forKey key: String, onSuccess: ([T]?) -> (), expired: () -> ()) {
        getObject(forKey: key) { (storable: StorableTimestampCollection<T>?) in
            if let storable = storable, storable.timestamp + timeInterval > Date().timeIntervalSince1970 {
                // if cached exists and timestamp is not older than 60 seconds, return item
                onSuccess(storable.collection)
            } else {
                expired()
            }
        }
    }

    func removeValue(forKey key: String, onSuccess: () -> ()) {
        objectStorage.removeObject(forKey: key)
        onSuccess()
    }

    func cleanStorage(onSuccess: () -> ()) {
        let dict = objectStorage.dictionaryRepresentation()
        for key in dict.keys {
            objectStorage.removeObject(forKey: key)
        }
        objectStorage.removeSuite(named: storage.storageIdentifier)
        // force synchronize as we've seen the cache not being refreshed at times
        let _ = objectStorage.synchronize()
        onSuccess()
    }

}
