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
    @BoundPointer
    static var trackedDirectories: [TrackedDirectory] = {
        defer {
            UserPreferences.onTrackedDirectoriesDidChange { (newTrackedDirectories) in
                UserPreferences.Bindings.trackedDirectories = newTrackedDirectories
                return .thisIsTheTailEndOfTheCallbackChain
            }
        }
        return UserPreferences.trackedDirectories
    }()
    
    
    @BoundPointer
    static var checkingDelay: Age = {
        defer {
            UserPreferences.onCheckingDelayDidChange { (newCheckingDelay) in
                UserPreferences.Bindings.checkingDelay = newCheckingDelay
                return .thisIsTheTailEndOfTheCallbackChain
            }
        }
        return UserPreferences.checkingDelay
    }()
}
