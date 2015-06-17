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
        switch self {
        case .Fulfilment(_ ):
            return true
        default:
            return false
        }
    }

    var error: NSError? {
        switch self {
        case .Error(let error):
            return error
        default:
            return nil
        }
    }

    var value: T? {
        switch self {
        case .Fulfilment(let value):
            return value.boxed
        default:
            return nil
        }
    }
}
