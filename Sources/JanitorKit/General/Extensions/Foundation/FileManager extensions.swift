//
//  FileManager extensions.swift
//  JanitorKit
//
//  Created by Ky Leggiero on 2021-07-30.
//

import Foundation



public extension FileManager {
    
    /// A file manager which performs no actions. No state will change at all, neither volatile nor persistent.
    ///
    /// All "read" operations will perform as always. All "write" operations will silently do nothing.
    /// For example, `isDeletableWritableFile(atPath:)` might return `true`, but `removeItem(atPath:)` will still not delete the file.
    ///
    /// Operations which provide a return value describing how they changed state, like `createFile(atPath:contents:)`, will accurately reuturn a value describing that the state was not changed.
    ///
    /// This performs as expected for Apple SDKs as of:
    /// - macOS 12
    /// - iOS 15
    /// - tvOS 15
    /// - watchOS 8
    ///
    /// Future SDKs might add new mutation methods. If so, this will _not_ perofrm as expected, since it works by overriding mutation methods with no-op versions, and the new ones would not be overridden.
    ///
    /// - Attention: If, for any reason, this changes any state, report that as a bug here: https://github.com/KyLeggiero/JanitorKit/issues/new
    static let dryRun: FileManager = DryRunFileManager()
}



/// The implementation behind `FileManager.dryRun`
private final class DryRunFileManager: FileManager {
    
    @nonobjc
    override func unmountVolume(at url: URL, options mask: FileManager.UnmountOptions = [], completionHandler: @escaping (Error?) -> Void) {}
    override func unmountVolume(at url: URL, options mask: FileManager.UnmountOptions = []) async throws {}
    
    override func createDirectory(at url: URL, withIntermediateDirectories createIntermediates: Bool, attributes: [FileAttributeKey : Any]? = nil) throws {}
    override func createDirectory(atPath path: String, withIntermediateDirectories createIntermediates: Bool, attributes: [FileAttributeKey : Any]? = nil) throws {}
    
    override func createSymbolicLink(at url: URL, withDestinationURL destURL: URL) throws {}
    override func createSymbolicLink(atPath path: String, withDestinationPath destPath: String) throws {}
    
    override func setAttributes(_ attributes: [FileAttributeKey : Any], ofItemAtPath path: String) throws {}
    
    override func copyItem(at srcURL: URL, to dstURL: URL) throws {}
    override func copyItem(atPath srcPath: String, toPath dstPath: String) throws {}
    
    override func moveItem(at srcURL: URL, to dstURL: URL) throws {}
    override func moveItem(atPath srcPath: String, toPath dstPath: String) throws {}
    
    override func linkItem(at srcURL: URL, to dstURL: URL) throws {}
    override func linkItem(atPath srcPath: String, toPath dstPath: String) throws {}
    
    override func removeItem(at URL: URL) throws {}
    override func removeItem(atPath path: String) throws {}
    
    override func trashItem(at url: URL, resultingItemURL outResultingURL: AutoreleasingUnsafeMutablePointer<NSURL?>?) throws {}
    
    override func changeCurrentDirectoryPath(_ path: String) -> Bool { false }
    
    override func createFile(atPath path: String, contents data: Data?, attributes attr: [FileAttributeKey : Any]? = nil) -> Bool { false }
    
    override func replaceItem(at originalItemURL: URL, withItemAt newItemURL: URL, backupItemName: String?, options: FileManager.ItemReplacementOptions = [], resultingItemURL resultingURL: AutoreleasingUnsafeMutablePointer<NSURL?>?) throws {}
    
    override func setUbiquitous(_ flag: Bool, itemAt url: URL, destinationURL: URL) throws {}
    override func startDownloadingUbiquitousItem(at url: URL) throws {}
    override func evictUbiquitousItem(at url: URL) throws {}
}
