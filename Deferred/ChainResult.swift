//
//  ChainResult.swift
//  DeferredExample
//
//  Created by Mark Pervovskiy on 17/11/14.
//  Copyright (c) 2014 Mark Pervovskiy. All rights reserved.
//

import Foundation

/*
Represents result of chain operation.
*/

public enum ChainResult<T> {
    case Fulfilment(Box<T>)
    case Error(NSError)

    init(_ value: T) {
        self = .Fulfilment(Box(value))
    }

    init(_ error: NSError) {
        self = .Error(error)
    }

    var fulfilled: Bool {
        if case .Fulfilment(_) = self { return true }
        return false
    }

    var error: NSError? {
        if case let .Error(error) = self { return error }
        return nil
    }

    var value: T? {
        if case let .Fulfilment(value) = self { return value.boxed }
        return nil
    }
}
