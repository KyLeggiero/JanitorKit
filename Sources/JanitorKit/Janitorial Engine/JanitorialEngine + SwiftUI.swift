//
//  JanitorialEngine + SwiftUI.swift
//  JanitorKit
//
//  Created by Ky Leggiero on 2021-07-25.
//

#if canImport(SwiftUI)
import SwiftUI



public extension JanitorialEngine {
    struct EnvironmentKey: SwiftUI.EnvironmentKey {
        public static var defaultValue = JanitorialEngine?.none
    }
}



public extension JanitorialEngine.ActivityFeed {
    struct EnvironmentKey: SwiftUI.EnvironmentKey {
        public static let defaultValue = JanitorialEngine.ActivityFeed.dummyThatNeverPublishes()
    }
}



public extension EnvironmentValues {
    
    var janitorialEngine: JanitorialEngine? {
        get { self[JanitorialEngine.EnvironmentKey.self] }
        set { self[JanitorialEngine.EnvironmentKey.self] = newValue }
    }
    
    var janitorialEngineActivityFeed: JanitorialEngine.ActivityFeed {
        get { self[JanitorialEngine.ActivityFeed.EnvironmentKey.self] }
//        set { self[JanitorialEngine.ActivityFeed.EnvironmentKey.self] = newValue }
    }
}

#endif
