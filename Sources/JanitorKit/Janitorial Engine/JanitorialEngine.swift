//
//  JanitorialEngine.swift
//  JanitorKit
//
//  Created by Ky Leggiero on 2021-07-25.
//

import Foundation

import CollectionTools



/// The core engine of Janitor. This coordinates multiple Single-Directory Janitors, taking care of their lifecycles and concurrency
public final actor JanitorialEngine {
    
    private var janitors: [SingleDirectoryJanitor] = []
    
    /// Whether to perform a "dry run", where actions are pretended but no changes are made.
    ///
    /// - Attention: This is an expensive operation! Do not toggle this lightly; all janitors will be immediately stopped, reconfigured, and started again
    fileprivate var _dryRun: Bool {
        didSet {
            if oldValue != _dryRun {
                stopAll()
                startAll()
            }
        }
    }
    
    
    public init(dryRun: Bool = false, coordinating janitors: [SingleDirectoryJanitor]) async {
        self._dryRun = dryRun
        self.janitors = janitors
        
        Task(priority: Self.taskPriority) {
            await self.startAll()
        }
    }
}



public extension JanitorialEngine {
    
    convenience init(dryRun: Bool = false, coordinatingJanitorsFor trackedDirectories: [TrackedDirectory]) async {
        await self.init(dryRun: dryRun, coordinating: trackedDirectories.map { SingleDirectoryJanitor(trackedDirectory: $0) })
    }
    
    
    nonisolated var trackedDirectories: [TrackedDirectory] {
        get { enqueue { [self] in await janitors.map(\.trackedDirectory) } }
        set {
            enqueue { [self] in
                let changes = await janitors.map(\.trackedDirectory).difference(from: newValue)
                
                for change in changes {
                    switch change {
                    case .insert(offset: _, element: let newDirectory, associatedWith: _):
                        await self.coordinate(janitor: .init(trackedDirectory: newDirectory))
                        
                    case .remove(offset: _, element: let oldDirectory, associatedWith: _):
                        await self.retire(janitorTracking: oldDirectory)
                    }
                }
            }
        }
    }
    
    
    /// Coordinates the given janitor with exiting ones, to ensure it can clean its directory efficiently.
    ///
    /// This inherently starts the janitor immediately.
    ///
    /// - Parameter janitor: The janitor to coordinate
    func coordinate(janitor: SingleDirectoryJanitor) async {
        self.janitors += janitor
        
        start(janitor)
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
    
    
    func setDryRun(_ closure: @escaping @Sendable @autoclosure () -> Bool) {
        _dryRun = closure()
    }
    
    
    nonisolated var dryRun: Bool {
        get { enqueue { await self._dryRun } }
        set { enqueue { await self.setDryRun(newValue)} }
    }
}



private extension JanitorialEngine {
    
    static let taskPriority = TaskPriority.background
    
    
    func startAll() {
        enqueue { [self] in
            for janitor in await janitors {
                await janitor.start(dryRun: _dryRun)
            }
        }
    }
    
    
    func stopAll() {
        enqueue { [self] in
            for janitor in await janitors {
                await janitor.stop()
            }
        }
    }
    
    
    func start(_ janitor: SingleDirectoryJanitor) {
        enqueue { [self] in
            await janitor.start(dryRun: _dryRun)
        }
    }
    
    
    func stop(_ janitor: SingleDirectoryJanitor) {
        enqueue {
            await janitor.stop()
        }
    }
}



private func enqueue(_ task: @escaping @Sendable () async -> Void) {
    Task(priority: JanitorialEngine.taskPriority) {
        await task()
    }
}


private func enqueue<Value>(_ task: @escaping @Sendable () async -> Value) -> Value {
    sync(at: JanitorialEngine.taskPriority, task)
}
