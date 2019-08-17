//
//  JanitorialEngine.swift
//  JanitorKit
//
//  Created by Ben Leggiero on 8/3/19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import Foundation



/// The core engine of Janitor. This will dedicate itself to ensuring that one directory never gets out of control, by
/// trashing files which are older than a certain age, or which push that directory over a certain size.
///
/// This was designed to have multiple engines running at once; one for each tracked directory.
public class JanitorialEngine {
    public var trackedDirectory: TrackedDirectory {
        didSet {
            restart()
        }
    }
    
    public var checkingInterval: TimeInterval {
        didSet {
            restart()
        }
    }
    
    private var timer: Timer?
    
    public var deletionApproach = URL.DeleteApproach.trashing
    
    
    init(trackedDirectory: TrackedDirectory, checkingInterval: TimeInterval) {
        self.trackedDirectory = trackedDirectory
        self.checkingInterval = checkingInterval
    }
}



public extension JanitorialEngine {
    
    /// Starts the janitorial engine, immediately performing the check and
    ///
    /// - Parameter callback: _optional_ Called after the engine starts and the first check is successfully performed
    @discardableResult
    func start(andThen callback: @escaping DidStartCallback = blackhole) -> ReturnsViaCallback {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: checkingInterval, repeats: true, block: timerDidFire)
        return performCheck { result in
            return callback()
        }
    }
    
    
    /// Immediately stops the janitorial engine. No questions asked, no strings attached
    ///
    /// - Parameter callback: _optional_ Called immediately after the engine was successfully stopped
    @discardableResult
    func stop(andThen callback: @escaping DidStopCallback = blackhole) -> ReturnsViaCallback {
        timer?.invalidate()
        timer = nil
        return callback()
    }
    
    
    /// Calls for the timer to stop and start again
    ///
    /// - Parameter callback: _optional_ Called after the engine restarts and the first check is successfully performed
    @discardableResult
    func restart(andThen callback: @escaping DidRestartCallback = blackhole) -> ReturnsViaCallback {
        stop {
            self.start(andThen: callback)
        }
    }
    
    
    
    /// The kind of block called when the engine successfully starts
    typealias DidStartCallback = BlindCallback
    
    /// The kind of block called when the engine successfully stops
    typealias DidStopCallback = BlindCallback
    
    /// The kind of block called when the engine successfully restarts
    typealias DidRestartCallback = DidStartCallback
}



private extension JanitorialEngine {
    
    func timerDidFire(_ timer: Timer) {
        performCheck()
    }
    
    
    @discardableResult
    func performCheck(andThen callback: @escaping DidPreformCheckCallback = blackhole) -> ReturnsViaCallback {
        let filesThatShouldBeDeleted = trackedDirectory.filesThatShouldBeDeleted
        
        guard !filesThatShouldBeDeleted.isEmpty else {
            return callback(.allFilesWereGood)
        }
        
        return filesThatShouldBeDeleted.deleteAll(by: .trashing) { batchDeleteResult in
                switch batchDeleteResult {
                case .allSuccess:
                    return callback(.successfullyCleaned(cleanedUpFiles: filesThatShouldBeDeleted))
                    
                case .mixed(let successes, let remainingErrors):
                    return callback(.failedToCleanSomeBadFiles(cleanedUpFiles: successes, uncleanFiles: remainingErrors))
                    
                case .allFailed(let uncleanFiles):
                    return callback(.failedToCleanAllBadFiles(uncleanFiles: uncleanFiles))
                }
        }
    }
    
    
    
    typealias DidPreformCheckCallback = Callback<CheckResult>
    
    
    
    enum CheckResult {
        case allFilesWereGood
        case successfullyCleaned(cleanedUpFiles: Set<URL>)
        case failedToCleanAllBadFiles(uncleanFiles: Set<UncleanFile>)
        case failedToCleanSomeBadFiles(cleanedUpFiles: Set<URL>, uncleanFiles: Set<UncleanFile>)
    }
    
    
    
    typealias UncleanFile = DeletionFailure
}
