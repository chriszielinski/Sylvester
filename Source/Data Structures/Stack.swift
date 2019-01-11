//
//  Stack.swift
//  Sylvester 😼
//
//  Created by Chris Zielinski on 7/30/18.
//  Copyright © 2018 Big Z Labs. All rights reserved.
//

/// Last-in first-out stack (LIFO)
/// Push and pop are O(1) operations.
///
/// - Author: [Swift Algorithm Club](https://github.com/raywenderlich/swift-algorithm-club)
public struct Stack<T> {

    fileprivate var array = [T]()

    public var isEmpty: Bool {
        return array.isEmpty
    }

    public var count: Int {
        return array.count
    }

    public mutating func push(_ element: T) {
        array.append(element)
    }

    public mutating func pop() -> T? {
        return array.popLast()
    }

    public mutating func pushUnderTop(_ element: T) {
        array.insert(element, at: array.endIndex - 1)
    }

    public mutating func popUnderTop() -> T? {
        return array.remove(at: array.endIndex - 2)
    }

    public var top: T? {
        return array.last
    }

}

// MARK: - Sequence Protocol

extension Stack: Sequence {

    public func makeIterator() -> AnyIterator<T> {
        var curr = self
        return AnyIterator {
            return curr.pop()
        }
    }

}
