//
//  SKSubprocess.swift
//  SylvesterCommon 😼
//
//  Created by Chris Zielinski on 1/22/19.
//  Copyright © 2019 Big Z Labs. All rights reserved.
//

import Foundation

public struct SKSubprocess: Codable {

    // MARK: - Open Stored Properties

    /// The URL to the receiver’s executable.
    public var executableURL: URL
    /// The arguments that should be used to launch the executable.
    public var arguments: [String]?
    /// The environment for the receiver.
    ///
    /// If `nil`, the environment is inherited from the process that created the receiver.
    public var environment: [String: String]?
    /// The current directory for the receiver.
    ///
    /// If `nil`, the current directory is inherited from the process that created the receiver.
    public var currentDirectoryURL: URL?
    /// Whether the standard error should also be piped to the output.
    public var shouldPipeStandardError: Bool = false

    // MARK: - Internal Computed Properties

    /// Initializes a `Process` with the subprocess's properties.
    internal var process: Process {
        let process = Process()

        if #available(OSX 10.13, *) {
            process.executableURL = executableURL
        } else {
            process.launchPath = executableURL.absoluteString
        }

        if let arguments = arguments {
            process.arguments = arguments
        }

        if let environment = environment {
            process.environment = environment
        }

        if let currentDirectoryURL = currentDirectoryURL {
            if #available(OSX 10.13, *) {
                process.currentDirectoryURL = currentDirectoryURL
            } else {
                process.currentDirectoryPath = currentDirectoryURL.absoluteString
            }
        }

        return process
    }

    // MARK: - Public Initializers

    public init(executableURL: URL) {
        self.executableURL = executableURL
    }

}
