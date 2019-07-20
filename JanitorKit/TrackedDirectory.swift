//
//  TrackedDirectory.swift
//  Janitor
//
//  Created by Ben Leggiero on 7/19/19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import Foundation



public struct TrackedDirectory {
    public let url: URL
    public let oldestAllowedAge: Age
    public let largestAllowedTotalSize: DataSize
    
    public init(url: URL, oldestAllowedAge: Age, largestAllowedTotalSize: DataSize) {
        self.url = url
        self.oldestAllowedAge = oldestAllowedAge
        self.largestAllowedTotalSize = largestAllowedTotalSize
    }
}



extension TrackedDirectory: Hashable {}
