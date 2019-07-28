//
//  UserPreferences.swift
//  JanitorKit
//
//  Created by Ben Leggiero on 7/19/19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import Foundation



public enum UserPreferences {
    // Empty on-purpose; all members are static
}



public extension UserPreferences {
    @UserDefault("trackedDirectories")
    static var trackedDirectories: [TrackedDirectory] = [
        TrackedDirectory(isEnabled: false, url: URL.User.downloads!, oldestAllowedAge: 30.days, largestAllowedTotalSize: 1.gibibytes),
        TrackedDirectory(isEnabled: false, url: URL.User.desktop!, oldestAllowedAge: 90.days, largestAllowedTotalSize: 5.gibibytes),
    ]
    
    @UserDefault("checkingDelay")
    static var checkingDelay = 5.minutes
}
