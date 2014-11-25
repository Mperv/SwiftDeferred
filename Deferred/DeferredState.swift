//
//  DeferredState.swift
//  DeferredExample
//
//  Created by Mark Pervovskiy on 17/11/14.
//  Copyright (c) 2014 Mark Pervovskiy. All rights reserved.
//

import Foundation

//should be generic, with value & error inside
public enum DeferredState {
    case None
    case Fulfilment
    case Error
}