//
//  SKCodeCompletionSession.swift
//  Sylvester 😼
//
//  Created by Chris Zielinski on 8/17/18.
//  Copyright © 2018 Big Z Labs. All rights reserved.
//

import SourceKittenFramework
import SylvesterCommon

/// Represents a _SourceKit_ code completion session, which can be filtered using update requests.
open class SKCodeCompletionSession: NSObject {

    // MARK: - Static Properties

    static let serialRequestQueue = DispatchQueue(label: Constants.Identifier.codeCompletionSessionQueue,
                                                  qos: .userInitiated,
                                                  autoreleaseFrequency: .workItem)

    // MARK: - Public Type Aliases

    public typealias CompletionHandler = (SKCodeCompletionSession, Response) -> Void
    public typealias ErrorHandler = (SKCodeCompletionSession, Response, SKError) -> Void
    public typealias Options = SKCodeCompletionSessionOptions
    public typealias Response = SKCodeCompletionSessionResponse

    // MARK: - Internal Stored Properties

    /// The compiler arguments used by the session.
    let compilerArguments: [String]
    /// A thread-safe wrapper for the number of outstanding session requests awaiting completion.
    let dispatchedQueueRequestCount: DispatchedValue<Int> = DispatchedValue(value: 0)

    // MARK: - Public Stored Properties

    /// The session source file.
    public let file: File
    /// The byte offset of the code completion point inside the session's source contents.
    public let offset: Offset
    /// The mutable code completion session options.
    ///
    /// These options can (should) be modified before sending an `update()`.
    public var options: SKCodeCompletionSession.Options? = SKCodeCompletionSession.Options()
    /// Whether previous requests should be canceled if a new request is made that uses different `options`.
    ///
    /// - Note: The previous requests are not actually canceled (because they are asynchronous, and
    ///         that ship has sailed); however, the completion handler will only be called with the
    ///         response of the most recently sent request.
    public var cancelOnSubsequentRequest: Bool = false

    /// A closure that receives the code completion request responses.
    public var completionHandler: CompletionHandler?
    /// A closure that receives any code completion request errors.
    public var errorHandler: ErrorHandler?

    /// Whether the session is open.
    ///
    /// This boolean indicates whether the session has been opened (`open()`) and not closed (`close()`).
    public internal(set) var isOpen: Bool = false
    /// The most recent request response received in the session.
    public internal(set) var latestResponse: Response?

    // MARK: - Public Computed Properties

    /// Whether there are any outstanding session requests awaiting completion.
    public var isActive: Bool {
        return queueRequestCount > 0
    }
    /// Whether the session has been closed (`close()`).
    ///
    /// - Note: This property will also be `false` if the session has not yet been opened (`open()`).
    public var isClosed: Bool {
        return !isOpen
    }
    /// The number of outstanding session requests awaiting completion.
    public var queueRequestCount: Int {
        return dispatchedQueueRequestCount.get()
    }

    // MARK: - Public Initializers

    /// Initializes a new _SourceKit_ code completion session object.
    ///
    /// - Note: This request needs to be opened (via the `open()` method).
    ///
    /// - Parameters:
    ///   - file: The source file.
    ///   - offset: The byte offset of the code completion point inside the source contents.
    ///   - compilerArguments: The compiler arguments used to build the module.
    public init(file: File,
                offset: Offset,
                compilerArguments: [String]) {
        self.file = file
        self.offset = offset
        self.compilerArguments = compilerArguments

        super.init()
    }

    /// Initializes a new _SourceKit_ code completion session object.
    ///
    /// - Note: This request needs to be opened (via the `open()` method).
    ///
    /// - Parameters:
    ///   - file: The source file.
    ///   - offset: The source code byte offset to use in the SourceKit request.
    ///   - sdkPath: The path to the SDK to compile against.
    ///   - target: The target (triple) architecture to generate completions for (e.g. `"arm64-apple-ios12.1"`).
    public convenience init(file: File,
                            offset: Offset,
                            sdkPath: String,
                            target: String? = nil) {
        var arguments = ["-sdk", sdkPath]
        if let target = target {
            arguments.append(contentsOf: ["-target", target])
        }

        self.init(file: file, offset: offset, compilerArguments: arguments)
    }

    /// Initializes a new _SourceKit_ code completion session object.
    ///
    /// - Note: This request needs to be opened (via the `open()` method).
    ///
    /// - Parameters:
    ///   - filePath: The file path of the source file.
    ///   - offset: The byte offset of code completion point inside the source contents.
    ///   - compilerArguments: The compiler arguments used to build the module.
    public convenience init(filePath: String,
                            offset: Offset,
                            compilerArguments: [String]) {
        self.init(file: File(pathDeferringReading: filePath),
                  offset: offset,
                  compilerArguments: compilerArguments)
    }

    /// Initializes a new _SourceKit_ code completion session object.
    ///
    /// - Note: This request needs to be opened (via the `open()` method).
    ///
    /// - Parameters:
    ///   - contents: The source code contents.
    ///   - offset: The byte offset of code completion point inside the source contents.
    ///   - compilerArguments: The compiler arguments used to build the module.
    public convenience init(contents: String,
                            offset: Offset,
                            compilerArguments: [String]) {
        self.init(file: File(contents: contents),
                  offset: offset,
                  compilerArguments: compilerArguments)
    }

    /// Initializes a new _SourceKit_ code completion session object.
    ///
    /// - Note: This request needs to be opened (via the `open()` method).
    ///
    /// - Parameters:
    ///   - filePath: The file path of the source file.
    ///   - offset: The byte offset of code completion point inside the source contents.
    ///   - sdkPath: The path to the SDK to compile against.
    ///   - target: The target (triple) architecture to generate completions for (e.g. `"arm64-apple-ios12.1"`).
    public convenience init(filePath: String,
                            offset: Offset,
                            sdkPath: String,
                            target: String? = nil) {
        self.init(file: File(pathDeferringReading: filePath),
                  offset: offset,
                  sdkPath: sdkPath,
                  target: target)
    }

    /// Initializes a new _SourceKit_ code completion session object.
    ///
    /// - Note: This request needs to be opened (via the `open()` method).
    ///
    /// - Parameters:
    ///   - contents: The source contents.
    ///   - offset: The byte offset of code completion point inside the source contents.
    ///   - sdkPath: The path to the SDK to compile against.
    ///   - target: The target (triple) architecture to generate completions for (e.g. `"arm64-apple-ios12.1"`).
    public convenience init(contents: String,
                            offset: Offset,
                            sdkPath: String,
                            target: String? = nil) {
        self.init(file: File(contents: contents),
                  offset: offset,
                  sdkPath: sdkPath,
                  target: target)
    }

    deinit {
        close(shouldDispatchAsynchronous: false)
    }

    // MARK: - Public Request Methods

    /// Opens the code completion session for the `file` at the byte `offset` with the specified `options`.
    public func open() {
        guard !isOpen
            else { return }

        dispatchedQueueRequestCount.set(queueRequestCount + 1)

        SKCodeCompletionSession.serialRequestQueue.async { [weak self, options] in
            // We don't want to create any strong reference cycles, so we're using a weak reference to `self`.
            // Make sure we (`self`) still exist and haven't been deallocated.
            guard let session = self
                else { return }

            do {
                let response = try SylvesterInterface.shared
                    .codeCompletionOpen(file: session.file,
                                            offset: session.offset,
                                            options: options,
                                            compilerArguments: session.compilerArguments)
                session.isOpen = true
                session.handleRequest(response: response)
            } catch {
                session.handleError(error.toSKError(),
                                    for: Response(kind: .open, options: session.options, codeCompletion: nil))
            }
        }
    }

    /// Updates an open code completion session with the specified `options`.
    public func update() {
        dispatchedQueueRequestCount.set(queueRequestCount + 1)

        SKCodeCompletionSession.serialRequestQueue.async { [weak self, options] in
            // We don't want to create any strong reference cycles, so we're using a weak reference to `self`.
            // Make sure we (`self`) still exist and haven't been deallocated.
            guard let session = self
                else { return }

            // Make sure the session is open.
            guard session.isOpen
                else { return }

            do {
                let response = try SylvesterInterface.shared.codeCompletionUpdate(file: session.file,
                                                                                     offset: session.offset,
                                                                                     options: options)
                session.handleRequest(response: response)
            } catch {
                session.handleError(error.toSKError(),
                                    for: Response(kind: .update, options: options, codeCompletion: nil))
            }
        }
    }

    /// Closes an opened code completion session.
    public func close() {
        close(shouldDispatchAsynchronous: true)
    }

    // MARK: - Internal Request Methods

    /// Closes an opened code completion session.
    ///
    /// - Parameter shouldDispatchAsynchronous: Whether the close request should be dispatched asynchronously, and
    ///                                         the appropriate handler (completion or error) be called.
    func close(shouldDispatchAsynchronous: Bool) {
        guard isOpen
            else { return }

        isOpen = false

        let sendCloseRequest: (SKCodeCompletionSession) -> Void = { (session) in
            do {
                let response = try SylvesterInterface.shared.codeCompletionClose(name: session.file.name,
                                                                                    offset: session.offset)
                if shouldDispatchAsynchronous {
                    session.handleRequest(response: response)
                }
            } catch {
                if shouldDispatchAsynchronous {
                    session.handleError(error.toSKError(),
                                        for: Response(kind: .close, options: nil, codeCompletion: nil))
                } else {
                    Utilities.print(error: error)
                }
            }
        }

        if shouldDispatchAsynchronous {
            dispatchedQueueRequestCount.set(queueRequestCount + 1)

            SKCodeCompletionSession.serialRequestQueue.async { [weak self] in
                // We don't want to create any strong reference cycles, so we're using a weak reference to `self`.
                // Make sure we (`self`) still exist and haven't been deallocated.
                guard let session = self
                    else { return }

                sendCloseRequest(session)
            }
        } else {
            sendCloseRequest(self)
        }
    }

    // MARK: - Internal Handler Methods

    /// Handles the code completion session request responses.
    func handleRequest(response: Response) {
        latestResponse = response
        dispatchedQueueRequestCount.set(queueRequestCount - 1)

        // If `cancelOnSubsequentRequest` is false, OR `cancelOnSubsequentRequest` is true (implied) AND there
        // are no active requests, then call the completion handler.
        if !cancelOnSubsequentRequest || !isActive {
            completionHandler?(self, response)
        }
    }

    func handleError(_ error: SKError, for response: Response) {
        Utilities.print(error: error)
        dispatchedQueueRequestCount.set(queueRequestCount - 1)
        errorHandler?(self, response, error)
    }

}
