//
//  SingleDirectoryJanitor.swift
//  JanitorKit
//
//  Created by Ky Leggiero on 2019-08-03.
//  Copyright © 2019 Ky Leggiero BH-1-PS
//

import Combine
import Foundation



/// This will dedicate itself to ensuring that one directory never gets out of control, by
/// trashing files which are older than a certain age, or which push that directory over a certain size.
///
/// This was designed to have multiple engines running at once; one for each tracked directory.
public actor SingleDirectoryJanitor {
    
    /// The directory that this janitor is tracking
    public nonisolated let trackedDirectory: TrackedDirectory
    
    private let checkingInterval: TimeInterval
    
    private var timer: AnyCancellable?
    
    private let deletionApproach: URL.DeleteApproach
    
    
    public init(
        trackedDirectory: TrackedDirectory,
        checkingInterval: TimeInterval,
        deletionApproach: URL.DeleteApproach = .trashing)
    {
        self.trackedDirectory = trackedDirectory
        self.checkingInterval = checkingInterval
        self.deletionApproach = deletionApproach
    }
    
    
    deinit {
        stop()
    }
}



public extension SingleDirectoryJanitor {
    
    convenience init(
        trackedDirectory: TrackedDirectory,
        deletionApproach: URL.DeleteApproach = .trashing)
    {
        
        
        self.init(
            trackedDirectory: trackedDirectory,
            checkingInterval: (10.seconds ... 5.minutes).clamp(trackedDirectory.oldestAllowedAge)
                .converted(to: .second).value,
            deletionApproach: deletionApproach)
    }
    
    /// Starts the janitorial engine, immediately performing the check and
    /// - Parameter dryRun: If `true`, no files will be deleted, but lines will be logged describing the action that would have been taken instead
    func start(dryRun: Bool) async {
//        fatalError()
        stop()
        
        timer = Timer.publish(every: checkingInterval, on: .current, in: .default)
            .sink { [self] _ in Task { _ = await enqueueCheck(dryRun: dryRun) } }
        
        await performCheck(dryRun: dryRun)
    }
    
    
    /// Immediately stops the janitorial engine. No questions asked, no strings attached
    func stop() {
        timer?.cancel()
        timer = nil
    }
    
    
    
    /// The kind of block called when the engine successfully starts
    typealias DidStartCallback = StrongBlindCallback
    
    /// The kind of block called when the engine successfully stops
    typealias DidStopCallback = StrongBlindCallback
    
    /// The kind of block called when the engine successfully restarts
    typealias DidRestartCallback = DidStartCallback
}



private extension SingleDirectoryJanitor {
    
    func enqueueCheck(dryRun: Bool, andThen callback: @escaping DidPreformCheckCallback = blackhole) -> ReturnsViaCallback {
        Task(priority: .background) {
            _ = callback(await performCheck(dryRun: dryRun))
        }
        
        return .willCallCallbackOnALaterIteration
    }
    
    
    @discardableResult
    func performCheck(dryRun: Bool) async -> CheckResult {
        let filesThatShouldBeDeleted = await trackedDirectory.filesThatShouldBeDeleted()
        
        guard !filesThatShouldBeDeleted.isEmpty else {
            return .allFilesWereGood
        }
        
        let batchDeleteResult = await filesThatShouldBeDeleted.deleteAll(by: .trashing, using: dryRun ? .dryRun : .default)
        
        switch batchDeleteResult {
        case .allSuccess:
            return .successfullyCleaned(cleanedUpFiles: filesThatShouldBeDeleted)
            
        case .mixed(let successes, let remainingErrors):
            return .failedToCleanSomeBadFiles(cleanedUpFiles: successes, uncleanFiles: remainingErrors)
            
        case .allFailed(let uncleanFiles):
            return .failedToCleanAllBadFiles(uncleanFiles: uncleanFiles)
        }
    }
    
    
    
    typealias DidPreformCheckCallback = StrongCallback<CheckResult>
    
    
    
    enum CheckResult {
        case allFilesWereGood
        case successfullyCleaned(cleanedUpFiles: Set<URL>)
        case failedToCleanAllBadFiles(uncleanFiles: Set<UncleanFile>)
        case failedToCleanSomeBadFiles(cleanedUpFiles: Set<URL>, uncleanFiles: Set<UncleanFile>)
    }
    
    
    
    typealias UncleanFile = DeletionFailure
}



extension SingleDirectoryJanitor: IdentifiableOnlyIfUsingSwiftUI {
    
    nonisolated public var id: TrackedDirectory.ID { trackedDirectory.id }
    
    
    public static func == (lhs: SingleDirectoryJanitor, rhs: SingleDirectoryJanitor) -> Bool {
        lhs.trackedDirectory == rhs.trackedDirectory
    }
    
    
    nonisolated public func hash(into hasher: inout Hasher) {
        hasher.combine(trackedDirectory)
    }
}
