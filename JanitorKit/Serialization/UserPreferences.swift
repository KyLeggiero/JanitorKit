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



extension UserPreferences {
    @UserDefault("trackedDirectories")
    public static var trackedDirectories = [TrackedDirectory]()
    
    @UserDefault("checkingDelay")
    public static var checkingDelay = 5.minutes
}
