//
//  TrackedDirectory.swift
//  Janitor
//
//  Created by Ben Leggiero on 7/19/19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import Foundation



public struct TrackedDirectory {
    public var isEnabled: Bool
    public var url: URL
    public var oldestAllowedAge: Age
    public var largestAllowedTotalSize: DataSize
    
    public init(isEnabled: Bool = true, url: URL, oldestAllowedAge: Age, largestAllowedTotalSize: DataSize) {
        self.isEnabled = isEnabled
        self.url = url
        self.oldestAllowedAge = oldestAllowedAge
        self.largestAllowedTotalSize = largestAllowedTotalSize
    }
}



extension TrackedDirectory: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(url)
    }
}



extension TrackedDirectory: Codable {}
