//
//  StorableTimestampItem.swift
//  ForsythBarrKit
//
//  Created by Gligor Kotushevski on 4/07/19.
//  Copyright © 2019 Gligor Kotushevski. All rights reserved.
//

import Foundation

struct StorableTimestampItem<T: Codable>: Codable {
    let timestamp: TimeInterval
    let item: T
}

struct StorableTimestampCollection<T: Codable>: Codable {
    let timestamp: TimeInterval
    let collection: Array<T>
}
