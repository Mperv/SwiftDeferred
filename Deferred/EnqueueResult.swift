//
//  EnqueueResult.swift
//  DeferredExample
//
//  Created by Mark Pervovskiy on 17/11/14.
//  Copyright (c) 2014 Mark Pervovskiy. All rights reserved.
//

import Foundation

public class EnqueueResult<T> {
    private var _fulfiled : Bool;
    public var fulfiled: Bool { get {return _fulfiled; }}
    
    private var _value: T?;
    public var value: T { get { return _value!; }}
    
    private var _error: NSError? = nil;
    public var error: NSError { get { return _error!; }}
    
    public init(_ value: T){
        _fulfiled = true;
        _value = value;
    }
    
    public init(error: NSError){
        _fulfiled = false;
        _error = error;
    }
}
