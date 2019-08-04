//
//  JanitorialEngine.swift
//  JanitorKit
//
//  Created by Ben Leggiero on 8/3/19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import Foundation



/// The core engine of Janitor. This will dedicate itself to ensuring that one directory never gets out of control, by
/// trashing files which are older than a certain age, or which push that directory over a certain size
public class JanitorialEngine {
    public var trackedDirectory: TrackedDirectory {
        didSet {
            restart()
        }
    }
    
    public var checkingInterval: TimeInterval
    
    private var timer: Timer?
    
    
    init(trackedDirectory: TrackedDirectory, checkingInterval: TimeInterval) {
        self.trackedDirectory = trackedDirectory
        self.checkingInterval = checkingInterval
    }
}



public extension JanitorialEngine {
    
    /// Starts the janitorial engine, immediately performing the check and
    ///
    /// - Parameter callback: _optional_ Called after the engine starts and the first check is successfully performed
    func start(andThen callback: @escaping DidStartCallback = blackhole) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: checkingInterval, repeats: true, block: timerDidFire)
        performCheck {
            callback()
        }
    }
    
    
    /// Immediately stops the janitorial engine. No questions asked, no strings attached
    ///
    /// - Parameter callback: _optional_ Called immediately after the engine was successfully stopped
    func stop(andThen callback: @escaping DidStopCallback = blackhole) {
        timer?.invalidate()
        timer = nil
        callback()
    }
    
    
    /// Calls for the timer to stop and start again
    ///
    /// - Parameter callback: _optional_ Called after the engine restarts and the first check is successfully performed
    func restart(andThen callback: @escaping DidRestartCallback = blackhole) {
        stop {
            self.start(andThen: callback)
        }
    }
    
    
    
    /// The kind of block called when the engine successfully starts
    typealias DidStartCallback = () -> Void
    
    /// The kind of block called when the engine successfully stops
    typealias DidStopCallback = () -> Void
    
    /// The kind of block called when the engine successfully restarts
    typealias DidRestartCallback = DidStartCallback
}



private extension JanitorialEngine {
    
    func timerDidFire(_ timer: Timer) {
        performCheck()
    }
    
    
    func performCheck(andThen callback: DidPreformCheckCallback = blackhole) {
        trackedDirectory.filesThatShouldBeDeleted
            .deleteAll(by: .trashing)
    }
    
    
    
    typealias DidPreformCheckCallback = Callback<CheckResult>
}
