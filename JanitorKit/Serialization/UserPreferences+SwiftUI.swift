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
    static let trackedDirectories = Binding<[TrackedDirectory]>(
        getValue: {
            return UserPreferences.trackedDirectories
        },
        setValue: { newTrackedDirectories in
            UserPreferences.trackedDirectories = newTrackedDirectories
        }
    )

    static let checkingDelay = Binding<Age>(
        getValue: {
            return UserPreferences.checkingDelay
        },
        setValue: { newCheckingDelay in
            UserPreferences.checkingDelay = newCheckingDelay
        }
    )
}
