//  *******************************************************************************
//  The MIT License (MIT)
//
//  Copyright (c) 2017 Jean-David Gadina - www.xs-labs.com
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//  ******************************************************************************

/// Thread-safe value wrapper, using dispatch queues to achieve synchronization.
///
/// - Note: This class is not KVO-compliant. If you need this, please use subclasses of `DispatchedValue`.
///
/// - SeeAlso: DispatchedValueWrapper
public class DispatchedValue<T>: DispatchedValueWrapper {

    /// The wrapped value type.
    public typealias ValueType = T

    private let key  = DispatchSpecificKey<String>()
    private let uuid = UUID().uuidString

    private var queue: DispatchQueue
    private var value: T

    /// Initializes a dispatched value object.
    ///
    /// This initializer will use the main queue for synchronization.
    ///
    /// - Parameter value: The initial value.
    public required convenience init(value: T) {
        self.init(value: value, queue: DispatchQueue.main)
    }

    /// Initializes a dispatched value object.
    ///
    /// - Parameters:
    ///   - value: The initial value.
    ///   - queue: The queue to use to achieve synchronization.
    public required init(value: T, queue: DispatchQueue) {
        self.queue = queue
        self.value = value

        queue.setSpecific(key: key, value: uuid)
    }

    /// Atomically gets the wrapped value.
    ///
    /// The getter will be executed on the queue specified in the initialzer.
    ///
    /// - Returns: The actual value.
    public func get() -> T {
        if DispatchQueue.getSpecific(key: key) == uuid {
            return value
        } else {
            return queue.sync { return value }
        }
    }

    /// Atomically sets the wrapped value.
    ///
    /// The setter will be executed on the queue specified in the initialzer.
    ///
    /// - Parameter value: The value to set.
    public func set(_ value: T) {
        if DispatchQueue.getSpecific(key: key) == uuid {
            self.value = value
        } else {
            queue.sync { self.value = value }
        }
    }

    /// Atomically executes a closure on the wrapped value.
    ///
    /// The closure will be passed the actual value of the wrapped value, and is guaranteed to be executed
    /// atomically, on the queue specified in the initialzer.
    ///
    /// - Parameter closure: The close to execute.
    public func execute(closure: (T) -> Void) {
        if DispatchQueue.getSpecific(key: key) == uuid {
            closure(value)
        } else {
            queue.sync { closure(value) }
        }
    }

    /// Atomically executes a closure on the wrapped value, returning some value.
    ///
    /// The closure will be passed the actual value of the wrapped value, and is guaranteed to be executed
    /// atomically, on the queue specified in the initialzer.
    ///
    /// - Parameter closure: The close to execute, returning some value.
    ///
    /// - Returns: The value returned by executing the closure.
    public func execute<R>(closure: (T) -> R) -> R {
        if DispatchQueue.getSpecific(key: key) == uuid {
            return closure(value)
        } else {
            return queue.sync { return closure(value) }
        }
    }

}
