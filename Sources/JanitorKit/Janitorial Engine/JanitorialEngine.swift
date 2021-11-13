//
//  JanitorialEngine.swift
//  JanitorKit
//
//  Created by Ky Leggiero on 2021-07-25.
//

import Combine
import Foundation

import CollectionTools



/// The core engine of Janitor. This coordinates multiple Single-Directory Janitors, taking care of their lifecycles and concurrency.
public final actor JanitorialEngine: ObservableObject {
    
    // MARK: Private
    
    /// The janitors performing the work within this engine
    private var janitors: [SingleDirectoryJanitor] = [] {
        didSet {
            publish(.janitorsChanged(newJanitors: janitors))
        }
    }
    
    
    /// The backend for the activity feed
    @MainActor
    @Published
    private var mostRecentActivity: ActivityOrPlaceholder = .placeholderWhileEngineStarts
    
    
    // MARK: Public
    
    /// Subscribe to this to receive updates about the janitorial engine and read its state
    public private(set) var activityFeed: ActivityFeed
    
    
    /// Whether to perform a "dry run", where actions are pretended but no changes are made.
    ///
    /// - Attention: Changing this is an expensive operation! Do not toggle this lightly; all janitors will be immediately stopped, reconfigured, and started again
    public private(set) var dryRun: Bool = false
    
    
    // MARK: Init
    
    /// Creates a new Janitorial Engine, but doesn't start it yet. After this, you must specifically call `start()` to start the engine.
    ///
    /// - Parameters:
    ///   - dryRun:   _optional_ - Iff `true`, no files will be removed, but this will act as if they were anyway. Defaults to `false`
    ///   - janitors: The janitors to start with. To coordinate more janitors later, call `.coordinate(janitor:)`
    public init(dryRun: Bool = false, preparing janitors: [SingleDirectoryJanitor]) async {
        
        self.dryRun = dryRun
        self.janitors = janitors
        self.activityFeed = .dummyThatNeverPublishes() // Gotta do this or else the Swift compiler gets worried that I'm accessing `mostRecentActivity` before `activityFeed` is initialized
        
        
        self.activityFeed = $mostRecentActivity.createActivityFeed()
        
        publish(.ready(initialJanitors: self.janitors))
    }
}



// MARK: - Public Interaction & Control

public extension JanitorialEngine {
    
    /// Creates a new Janitorial Engine, but doesn't start it yet. After this, you must specifically call `start()` to start the engine.
    ///
    /// - Parameters:
    ///   - dryRun:   _optional_ - Iff `true`, no files will be removed, but this will act as if they were anyway. Defaults to `false`
    ///   - trackedDirectories: The directories which should be kept clean. Janitors will be created for each one. To coordinate more later, call `.coordinate(janitorFor:)`
    convenience init(dryRun: Bool = false, preparingJanitorsFor trackedDirectories: [TrackedDirectory]) async {
        await self.init(dryRun: dryRun, preparing: trackedDirectories.map { SingleDirectoryJanitor(trackedDirectory: $0) })
    }
    
    
    /// A way to interpret the janitors in this engine as the directories they track
    var trackedDirectories: [TrackedDirectory] {
        get { janitors.map(\.trackedDirectory) }
    }
    
    
    /// A way to change the janitors in this engine using the directories they track
    func setTrackedDirectories(_ newValue: [TrackedDirectory]) async {
        let changes = newValue.difference(from: janitors.map(\.trackedDirectory))
        
        for change in changes {
            switch change {
            case .insert(offset: _, element: let newDirectory, associatedWith: _):
                await self.coordinate(janitor: .init(trackedDirectory: newDirectory))
                
            case .remove(offset: _, element: let oldDirectory, associatedWith: _):
                await self.retire(janitorTracking: oldDirectory)
            }
        }
    }
    
    
    /// Changes whether this engine is running in "dry run" mode, meaning it will pretend to delete items but won't actually perform the deletion
    ///
    /// - Attention: Changing this is an expensive operation! Do not toggle this lightly; all janitors will be immediately stopped, reconfigured, and started again
    func setDryRun(_ newValue: Bool) async {
        let oldValue = self.dryRun
        self.dryRun = newValue
        
        if oldValue != newValue {
            await restartAll()
        }
    }
    
    
    /// Starts the janitorial engine, coordinating all its janitors to keep their directories clean
    func start() async {
        await startAll()
    }
    
    
    /// Coordinates a new janitor with exiting ones, to ensure it can clean its directory efficiently, the new one dedicated to the given tracked directory.
    ///
    /// This inherently starts the new janitor immediately.
    ///
    /// - Parameter trackedDirectory: The directory for the new janitor to be coordinated
    func coordinate(janitorFor trackedDirectory: TrackedDirectory) async {
        await coordinate(janitor: .init(trackedDirectory: trackedDirectory))
    }
    
    
    /// Coordinates the given janitor with exiting ones, to ensure it can clean its directory efficiently.
    ///
    /// This inherently starts the janitor immediately.
    ///
    /// - Parameter janitor: The janitor to coordinate
    func coordinate(janitor: SingleDirectoryJanitor) async {
        self.janitors += janitor
        
        await start(janitor)
    }
    
    
    /// Stops coordinating the given janitor.
    ///
    /// This inherently stops the janitor immediately.
    ///
    /// - Parameter janitor: The janitor to stop coordinating
    func retire(janitor: SingleDirectoryJanitor) async {
        self.janitors.remove(firstElementWithId: janitor.id)
    }
    
    
    func retire(janitorTracking directoryToRemove: TrackedDirectory) async {
        if let foundIndex = janitors.firstIndex(where: { $0.trackedDirectory == directoryToRemove }) {
            janitors.remove(at: foundIndex)
        }
    }
    
    
//    private func _setDryRun(_ closure: @escaping @Sendable @autoclosure () -> Bool) {
//        _dryRun = closure()
//    }
    
    
//    nonisolated var dryRun: Bool {
//        get { enqueue { await self._dryRun } }
//        set { enqueue { await self._setDryRun(newValue)} }
//    }
}



// MARK: - Activity feed

private extension JanitorialEngine {
    @frozen
    enum ActivityOrPlaceholder {
        case placeholderWhileEngineStarts
        case activity(Activity)
    }
}



public extension JanitorialEngine {
    
    /// An item of activity performed by this janitorial engine
    enum Activity {
        
        /// An error occurred
        case error(JanitorialEngine.Error)
        
        /// The janitorial engine has initialized and is ready to start coordinating janitors
        case ready(initialJanitors: [SingleDirectoryJanitor])
        
        /// The janitors this engine coordinates have changed
        case janitorsChanged(newJanitors: [SingleDirectoryJanitor])
        
        /// The janitorial engine has started the given janitor
        case janitorDidStart(id: SingleDirectoryJanitor.ID)
        
        /// The janitorial engine has stopped the given janitor
        case janitorDidStop(id: SingleDirectoryJanitor.ID)
        
        /// An item was removed from the drive
        case didRemoveItem
        
        /// The engine's "dry run" state changed
        case dryRunDidChange(newValue: Bool)
    }
}



public extension JanitorialEngine {
    enum Error: Swift.Error {
        
        /// An error occurred which was wholly unexpected by the developers of `JanitorKit`, so can't be expressed semantically at compile-time
        case unexpectedError(Swift.Error)
        
        /// A janitor coordinated by this engine tried to remove an item, but could not
        case couldNotRemoveItem(failedItem: AnnotatedFile, failureReason: Swift.Error)
    }
}



public extension JanitorialEngine {
    
    typealias ActivityFeed = AnyPublisher<Activity, Never>
}



private extension JanitorialEngine {
    
    /// Tells all subscribers that the given activity has occurred
    ///
    /// - Parameter activity: The activity to publish to subscribers
    nonisolated func publish(_ activity: Activity) {
        Task {
            await MainActor.run {
                self.mostRecentActivity = .activity(activity)
            }
        }
    }
}



private extension Published.Publisher where Value == JanitorialEngine.ActivityOrPlaceholder {
    func createActivityFeed() -> JanitorialEngine.ActivityFeed {
        compactMap { activityOrError in
            switch activityOrError {
            case .activity(let activity):
                return activity
                
            case .placeholderWhileEngineStarts:
                return nil
            }
        }
        .eraseToAnyPublisher()
    }
}



public extension JanitorialEngine.ActivityFeed {
    var onlyDryRunChanges: AnyPublisher<Bool, Never> {
        compactMap { activity in
            switch activity {
            case .dryRunDidChange(newValue: let dryRun):
                return dryRun
                
            default:
                return nil
            }
        }
        .eraseToAnyPublisher()
    }
}



// MARK: - Private conveniences

private extension JanitorialEngine {
    
    static let taskPriority = TaskPriority.background
    
    
    func startAll() async {
        await enqueue { [self] in
            for janitor in await janitors {
                await self._start(janitor)
            }
        }
    }
    
    
    func stopAll() async {
        await enqueue { [self] in
            for janitor in await janitors {
                await self._stop(janitor)
            }
        }
    }
    
    
    func restartAll() async {
        await enqueue { [self] in
            for janitor in await janitors {
                await self._stop(janitor)
                await self._start(janitor)
            }
        }
    }
    
    
    func start(_ janitor: SingleDirectoryJanitor) async {
        await enqueue { [self] in
            await self._start(janitor)
        }
    }
    
    
    func stop(_ janitor: SingleDirectoryJanitor) async {
        await enqueue {
            await self._stop(janitor)
        }
    }
    
    
    func restart(_ janitor: SingleDirectoryJanitor) async {
        await enqueue { [self] in
            await self._stop(janitor)
            await self._start(janitor)
        }
    }
    
    
    func _start(_ janitor: SingleDirectoryJanitor) async {
        await janitor.start(dryRun: dryRun)
        publish(.janitorDidStart(id: janitor.id))
    }
    
    
    func _stop(_ janitor: SingleDirectoryJanitor) async {
        await janitor.stop()
        publish(.janitorDidStop(id: janitor.id))
    }
}



private func enqueue(_ task: @escaping @Sendable () async -> Void) {
    Task(priority: JanitorialEngine.taskPriority) {
        await task()
    }
}
