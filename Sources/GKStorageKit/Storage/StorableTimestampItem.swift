//
//  PerishableItem.swift
//  GKStorageKit
//
//  Created by Gligor Kotushevski on 4/07/19.
//  Copyright © 2019 Gligor Kotushevski. All rights reserved.
//

import Foundation

struct PerishableItem<T: Codable>: Codable {
    let expireOn: TimeInterval
    let item: T
}

struct PerishableCollection<T: Codable>: Codable {
    let expireOn: TimeInterval
    let collection: Array<T>
}
