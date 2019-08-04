//
//  TrackedDirectory.swift
//  Janitor
//
//  Created by Ben Leggiero on 7/19/19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import Foundation



public struct TrackedDirectory {
    public let uuid: UUID
    public var isEnabled: Bool
    public var url: URL
    public var oldestAllowedAge: Age
    public var largestAllowedTotalSize: DataSize
    
    public init(uuid: UUID, isEnabled: Bool = true, url: URL, oldestAllowedAge: Age, largestAllowedTotalSize: DataSize) {
        self.uuid = uuid
        self.isEnabled = isEnabled
        self.url = url
        self.oldestAllowedAge = oldestAllowedAge
        self.largestAllowedTotalSize = largestAllowedTotalSize
    }
}



extension TrackedDirectory: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}



extension TrackedDirectory: Codable {}



extension TrackedDirectory: IdentifiableOnlyIfUsingSwiftUI {
    public var id: UUID { uuid }
}



public extension TrackedDirectory {
    /// The default instance of a tracked directory; a safe example to show and use as a base
    /// - Parameter customUuid: _optional_ - The UUID you want to use for the new default directory. If unspecified, a
    ///                         random new one will be created. If specified, that one will be used. Do **not** specify
    ///                         a UUID of an existing tracked directory will _not_ perform a lookup; it will only serve
    ///                         to create two tracked directories with the same UUID.
    static func `default`(customUuid: UUID = UUID()) -> TrackedDirectory {
        TrackedDirectory(uuid: customUuid,
                         url: URL.User.downloads!,
                         oldestAllowedAge: 30.days,
                         largestAllowedTotalSize: 1.gigabytes)
    }
}
