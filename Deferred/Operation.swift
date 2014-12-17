//
//  Operation.swift
//  DeferredExample
//
//  Created by Mark Pervovskiy on 17/12/14.
//  Copyright (c) 2014 Mark Pervovskiy. All rights reserved.
//

import Foundation

protocol Operation {
    typealias Input
    typealias Output
    
    func start (input: Input) -> EnqueueResult<Output>
}


infix operator |> {
associativity left
}

func |><Input, U : Operation where Input == U.Input>(deferred : Deferred<Input>, operation : U) -> Deferred<U.Output> {
    let result:Deferred<U.Output> = deferred.chain(queue: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {input in operation.start(input)}
    return result;
}