//
//  URL Extensions.swift
//  JanitorKit
//
//  Created by Ben Leggiero on 2019-08-03.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import Foundation



public extension URL {
    
    /// - Returns: An array of all child files in this directory.
    ///            If this is not a directory, or if there are no files, this returns `[]`
    ///
    /// - Parameter fileManager:     _optional_ The file manager which will be used to fetch the contents of this directory. Defaults to `.standard`
    /// - Parameter behavior: _optional_ Iff `true`, hidden files will **not** be returned. Defaults to `true`.
    /// - Parameter skipDirectories: _optional_ Iff `true`
    func allChildren(using fileManager: FileManager = .default, behavior: AllChildrenBehavior = .default) -> [URL] {
        let allChildren = (try? fileManager.contentsOfDirectory(at: self,
                                                                includingPropertiesForKeys: nil,
                                                                options: behavior.contains(.includeHiddenFiles) ? [] : .skipsHiddenFiles))
            ?? []
        
        if behavior.contains(.includeDirectories) {
            return allChildren
        }
        else {
            return allChildren.filter { $0.hasDirectoryPath }
        }
    }
    
    
    
    /// How the `allChildren` function should behave
    struct AllChildrenBehavior: OptionSet {
        public let rawValue: UInt8
        
        public init(rawValue: RawValue) {
            self.rawValue = rawValue
        }
        
        /// Hidden files should be included in the returned list of files
        public static let includeHiddenFiles = AllChildrenBehavior(rawValue: 1 << 0)
        
        /// Directories should be included in the returned list of files
        public static let includeDirectories = AllChildrenBehavior(rawValue: 1 << 1)
        
        /// The default behavior that `allChildren` uses
        public static let `default`: AllChildrenBehavior = []
    }
}



public extension URL {
    
    /// Returns this URL with some attributes annotated upon it
    var annotated: AnnotatedFile? {
        return AnnotatedFile(self)
    }
    
    
    /// Attempts to completely resolve this page
    var actualPath: String {
        return self.resolvingSymlinksInPath().standardizedFileURL.absoluteURL.path
    }
    
    
    /// Attempts to find the date at which the file was added to the directory
    var dateAdded: Date? {
        if let metadataItemValue = MDItemCreateWithURL(kCFAllocatorDefault, (self as CFURL)) {
            return MDItemCopyAttribute(metadataItemValue, kMDItemDateAdded) as? Date
        }
        return nil
    }
    
    
    /// Attempts to find the age of this file based on the user's preference for which age to regard
    ///
    /// - Parameter attributes: _optional_ The attributes from which to draw the age calculation. Based on the user's
    ///                         preference on which age to regard, this might never be used.
    func userSpecifiedAge() -> Age? {
        return userSpecifiedAge(using: try attributes())
    }
    
    
    /// Attempts to find the age of this file based on the user's preference for which age to regard
    ///
    /// - Parameter attributes: _optional_ The attributes from which to draw the age calculation. Based on the user's
    ///                         preference on which age to regard, this might never be used.
    func userSpecifiedAge(using attributes: @autoclosure FileAttributesGetter) -> Age? {
        return self.age(by: UserPreferences.whichAgeToRegard, using: try attributes())
    }
    
    
    /// Attempts to find the age of this file based on the specified age to regard
    ///
    /// - Parameter whichAgeToRegard: Which of the several kinds of ages will be regarded as the age of the file
    /// - Parameter attributes:       _optional_ The attributes from which to draw the age calculation. Based on the
    ///                               user's preference on which age to regard, this might never be used.
    func age(by whichAgeToRegard: WhichAgeToRegard) -> Age? {
        return age(by: whichAgeToRegard, using: try attributes())
    }
    
    
    /// Attempts to find the age of this file based on the specified age to regard
    ///
    /// - Parameter whichAgeToRegard: Which of the several kinds of ages will be regarded as the age of the file
    /// - Parameter attributes:       _optional_ The attributes from which to draw the age calculation. Based on the
    ///                               user's preference on which age to regard, this might never be used.
    func age(by whichAgeToRegard: WhichAgeToRegard, using attributes: @autoclosure FileAttributesGetter) -> Age? {
        func discoverDate() -> Date? {
            switch whichAgeToRegard {
            case .lastModificationDate:
                guard let attributes = try? attributes() else {
                    return nil
                }
                return modificationDate(using: attributes) ?? creationDate(using: attributes)
                
            case .originalCreationDate:
                guard let attributes = try? attributes() else {
                    return nil
                }
                return creationDate(using: attributes)
                
            case .dateWhenAddedToFolder:
                return self.dateAdded
            }
        }
        
        guard let date = discoverDate() else {
            return nil
        }
        
        return Age(value: date.timeIntervalSinceNow, unit: .second)
    }
    
    
    /// Attempts to find the modification date of this file
    ///
    /// - Parameter attributes: _optional_ The attributes from which to draw the modification date
    func modificationDate() -> Date? {
        guard let attributes = try? attributes() else { return nil }
        return modificationDate(using: attributes)
    }
    
    
    /// Attempts to find the modification date of this file
    ///
    /// - Parameter attributes: _optional_ The attributes from which to draw the modification date
    func modificationDate(using attributes: FileAttributes) -> Date? {
        return attributes[.modificationDate] as? Date
    }
    
    
    /// Attempts to find the creation date of this file
    ///
    /// - Parameter attributes: _optional_ The attributes from which to draw the creation date
    func creationDate(using attributes: FileAttributes) -> Date? {
        return attributes[.creationDate] as? Date
    }
    
    
    /// Attempts to find the creation date of this file
    ///
    /// - Parameter attributes: _optional_ The attributes from which to draw the creation date
    func creationDate() -> Date? {
        guard let attributes = try? attributes() else { return nil }
        return creationDate(using: attributes)
    }
    
    
    func attributes(using fileManager: FileManager = .default) throws -> FileAttributes {
        return try fileManager.attributesOfItem(atPath: actualPath)
    }
    
    
    typealias FileAttributesGetter = () throws -> FileAttributes
}



public extension URL {
    
    /// Attempts to delete this file
    ///
    /// - Parameter approach:       _optional_ The approach by which to delete the file. Defaults to `.trashing`.
    /// - Parameter fileManager:    _optional_ The file manager which will carry out the deletion. Defaults to `.standard`.
    /// - Parameter queueGenerator: _optional_ The queue on which to perform the deletion. Defaults to `.newDeleteQueue()`.
    /// - Parameter callback:       Called when the deletion has finished.
    @discardableResult
    func delete(by approach: DeleteApproach = .trashing,
                using fileManager: FileManager = .default,
                on queue: DispatchQueue = .newDeleteQueue(),
                andThen callback: @escaping DeleteCallback) -> ReturnsViaCallback
    {
        queue.async {
            do {
                switch approach {
                case .removing:
                    try fileManager.removeItem(at: self)
                    
                case .trashing:
                    try fileManager.trashItem(at: self, resultingItemURL: nil)
                }
                return <-callback(.success)
            }
            catch {
                return <-callback(.otherFailure(error: error))
            }
        }
        
        return .willReturnFromUntypedContext
    }
    
    
    
    typealias DeleteCallback = StrongCallback<DeleteResult>
    
    
    
    /// How a file should be deleted
    enum DeleteApproach {
        /// The standard Unix remove; actually delete the file from the file system
        case removing
        
        /// Send the file to the trash so it can be recovered
        case trashing
    }
    
    
    
    enum DeleteResult {
        case success
        case lackOfPermissions
        case otherFailure(error: Error)
    }
}



public extension DispatchQueue {
    static func newDeleteQueue() -> DispatchQueue {
        return DispatchQueue(label: "Delete queue \(UUID())", qos: .utility)
    }
}



public extension Collection where Element == URL {
    
    /// Annotates every file and sorts that annotated collection so that the oldest ones are at the start of the array
    func annotatedAndSortedWithOldestAtStart() -> [AnnotatedFile] {
        
        func oldestFirst(a: AnnotatedFile, b: AnnotatedFile) -> Bool {
            if a.age > b.age {
                return .inAscendingOrder
            }
            else {
                return .inDecendingOrder
            }
        }
        
        
        return lazy
            .compactMap { $0.annotated }
            .sorted(by: oldestFirst)
    }
    
    
    /// Attempts to delete each and every file in this collection
    ///
    /// - Parameter approach:       _optional_ The approach by which to delete each file. Defaults to `.trashing`.
    /// - Parameter fileManager:    _optional_ The file manager which will carry out the deletion. Defaults to `.standard`.
    /// - Parameter queueGenerator: _optional_ The function which will generate a new queue on which to perform each deletion. Defaults to `{ .newDeleteQueue() }`.
    /// - Parameter callback:       Called when all the deletions have finished.
    @discardableResult
    func deleteAll(by approach: DeleteApproach,
                   using fileManager: FileManager = .default,
                   on queueGenerator: @escaping JanitorKit.Generator<DispatchQueue> = { .newDeleteQueue() },
                   andThen callback: @escaping BatchDeleteCallback) -> ReturnsViaCallback {
        var numberOfCompletedDeleteAttempts: UInt = 0
        var failures = Set<DeletionFailure>()
        var successfulDeletions = Set<URL>()
        let completionProcessingQueue = DispatchQueue(label: "Deletion Completion Processor \(UUID())", qos: .userInteractive)
        
        func onEachDeleted(url: URL, result: URL.DeleteResult) -> CallbackReturnType {
            completionProcessingQueue.sync {
                numberOfCompletedDeleteAttempts += 1
                
                switch result {
                case .success:
                    successfulDeletions.insert(url)
                    
                case .lackOfPermissions:
                    failures.insert(.init(url: url, error: LackOfPermissionsError()))
                    
                case .otherFailure(let error):
                    failures.insert(.init(url: url, error: error))
                }
                
                if numberOfCompletedDeleteAttempts >= count {
                    if failures.isEmpty {
                        return callback(.allSuccess)
                    }
                    else if failures.count >= numberOfCompletedDeleteAttempts {
                        return callback(.allFailed(errors: failures))
                    }
                    else {
                        return callback(.mixed(successfullyDeletedFiles: successfulDeletions,
                                               remainingErrors: failures))
                    }
                }
                else {
                    return .willCallCallbackOnALaterIteration
                }
            }
        }
        
        forEach { url in
            url.delete(by: approach, using: fileManager, on: queueGenerator()) { deleteResult in
                onEachDeleted(url: url, result: deleteResult)
            }
        }
        
        return .willReturnFromUntypedContext
    }
    
    
    
    typealias DeleteApproach = Element.DeleteApproach
    
    typealias BatchDeleteCallback = StrongCallback<BatchDeleteResult>
}



public struct DeletionFailure: Error, Hashable {
    public let url: URL
    public let error: Error
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(url)
        hasher.combine(bytes: withUnsafeBytes(of: error, echo))
    }
    
    
    public static func ==(lhs: DeletionFailure, rhs: DeletionFailure) -> Bool {
        return lhs.url == rhs.url
    }
}



public enum BatchDeleteResult {
    case allSuccess
    case mixed(successfullyDeletedFiles: Set<URL>, remainingErrors: Set<DeletionFailure>)
    case allFailed(errors: Set<DeletionFailure>)
}



public struct LackOfPermissionsError: Error {
}



public extension Dictionary where Key == FileAttributeKey {
    
    /// Gets and pareses the `.size` attribute out of this dictionary
    var size: DataSize? {
        guard let sizeNsNumber = self[.size] as? NSNumber else {
            return nil
        }
        
        return DataSize(value: sizeNsNumber.uintValue, unit: .byte)
    }
}



public typealias FileAttributes = [FileAttributeKey : Any]
