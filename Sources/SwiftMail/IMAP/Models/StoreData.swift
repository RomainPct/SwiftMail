// StoreData.swift
// Model for IMAP STORE command data

import Foundation
import NIOIMAPCore

/// The type of store operation
public enum StoreType {
    case add
    case remove
    case replace
    
    /// Convert to NIO StoreType
    internal func toNIO() -> NIOIMAPCore.StoreOperation {
        switch self {
        case .add:
            return .add
        case .remove:
            return .remove
        case .replace:
            return .replace
        }
    }
}

/// Represents the data for an IMAP STORE command
public struct StoreData {
    
    /// The flags to store
    public let flags: [Flag]
    
    /// The type of store operation
    public let storeType: StoreType
    
    /// Initialize with flags and store type
    /// - Parameters:
    ///   - flags: The flags to store
    ///   - storeType: The type of store operation
    public init(flags: [Flag], storeType: StoreType) {
        self.flags = flags
        self.storeType = storeType
    }
    
    /// Factory method for creating a StoreData with flags
    /// - Parameters:
    ///   - flags: The flags to store
    ///   - storeType: The type of store operation
    /// - Returns: A new StoreData instance
    public static func flags(_ flags: [Flag], _ storeType: StoreType) -> StoreData {
        return StoreData(flags: flags, storeType: storeType)
    }
    
    /// Convert to NIOIMAPCore.StoreData
    public func toNIO() -> NIOIMAPCore.StoreData {
        // Convert flags to NIOIMAPCore.Flag array
        let nioFlags = flags.map { $0.toNIO() }
        
        // Create and return NIOIMAPCore.StoreData with the appropriate operation and flags
        // Using the proper factory methods on StoreFlags
        let storeFlags: NIOIMAPCore.StoreFlags
        switch storeType {
        case .add:
            storeFlags = NIOIMAPCore.StoreFlags.add(silent: false, list: nioFlags)
        case .remove:
            storeFlags = NIOIMAPCore.StoreFlags.remove(silent: false, list: nioFlags)
        case .replace:
            storeFlags = NIOIMAPCore.StoreFlags.replace(silent: false, list: nioFlags)
        }
        return .flags(storeFlags)
    }
}

/// Represents the data for an IMAP STORE command
public struct GmailStoreData {
    
    /// The flags to store
    public let labels: [GmailLabel]
    
    /// The type of store operation
    public let storeType: StoreType
    
    /// Initialize with labels and store type
    /// - Parameters:
    ///   - labels: The labels to store
    ///   - storeType: The type of store operation
    public init(labels: [GmailLabel], storeType: StoreType) {
        self.labels = labels
        self.storeType = storeType
    }
    
    /// Factory method for creating a StoreData with flags
    /// - Parameters:
    ///   - labels: The labels to store
    ///   - storeType: The type of store operation
    /// - Returns: A new StoreData instance
    public static func labels(_ labels: [GmailLabel], _ storeType: StoreType) -> GmailStoreData {
        return GmailStoreData(labels: labels, storeType: storeType)
    }
    
    /// Convert to NIOIMAPCore.StoreData
    public func toNIO() -> NIOIMAPCore.StoreData {
        let storeFlags: NIOIMAPCore.StoreGmailLabels
        switch storeType {
        case .add:
            storeFlags = NIOIMAPCore.StoreGmailLabels.add(silent: false, gmailLabels: labels)
        case .remove:
            storeFlags = NIOIMAPCore.StoreGmailLabels.remove(silent: false, gmailLabels: labels)
        case .replace:
            storeFlags = NIOIMAPCore.StoreGmailLabels.replace(silent: false, gmailLabels: labels)
        }
        return .gmailLabels(storeFlags)
    }
}
