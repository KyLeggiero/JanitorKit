//
//  UserPreferences+SwiftUI.swift
//  JanitorKit
//
//  Created by Ben Leggiero on 7/26/19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import SwiftUI



public extension UserPreferences {
    enum Bindings {
        // Empty on-purpose; all members are static
    }
}



public extension UserPreferences.Bindings {
    static let trackedDirectories = Inout<[TrackedDirectory]>(
        get: {
            return UserPreferences.trackedDirectories
        },
        set: { newTrackedDirectories in
            UserPreferences.trackedDirectories = newTrackedDirectories
        }
    )

    static let checkingDelay = Inout<Age>(
        get: {
            return UserPreferences.checkingDelay
        },
        set: { newCheckingDelay in
            UserPreferences.checkingDelay = newCheckingDelay
        }
    )
}
