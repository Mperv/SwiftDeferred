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
        switch self {
        case .Fulfilled(_ ):
            return true
        default:
            return false
        }
    }

    var resolved: Bool {
        switch self {
        case .None:
            return false
        default:
            return true
        }
    }

    var error: NSError? {
        switch self {
        case .Rejected(let error):
            return error
        default:
            return nil
        }
    }

    var value: T? {
        switch self {
        case .Fulfilled(let value):
            return value.boxed
        default:
            return nil
        }
    }
}