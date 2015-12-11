//
//  DeferredState.swift
//  DeferredExample
//
//  Created by Mark Pervovskiy on 17/11/14.
//  Copyright (c) 2014 Mark Pervovskiy. All rights reserved.
//

import Foundation

/*
Represents state of Deferred.
Deferred can be in three states:
    - None: work in progress
    - Fulfilled: work is finished successfully, result is available
    - Rejected: work is finished unsuccessfully, error is available
*/

public enum DeferredState<T> {
    case None
    case Fulfilled(Box<T>)
    case Rejected(NSError)

    init(_ value: T) {
        self = .Fulfilled(Box(value))
    }

    init(_ error: NSError) {
        self = .Rejected(error)
    }

    var fulfilled: Bool {
        if case .Fulfilled(_) = self { return true }
        return false
    }

    var resolved: Bool {
        if case .None = self { return false }
        return true
    }

    var error: NSError? {
        if case let .Rejected(error) = self { return error }
        return nil
    }

    var value: T? {
        if case let .Fulfilled(value) = self { return value.boxed }
        return nil
    }
}