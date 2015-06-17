SwiftDeferred
=============

Type-safe, thread-safe and chainable Swift implementation of Deferred. Deferred represents work that is not finished.
Deferred can be in three states:

- None: work in progress
- Fulfilled: work is finished successfully, result is available
- Rejected: work is finished unsuccessfully, error is available

Once resolved (either fulfilled or rejected) Deferred should be unable to change its state.

Usage:

```swift
let deferred = Deferred<Int>()
deferred.addCallback {
    println($0)
}
```
Will print `2` after `deferred.fulfill(2)` is called.

The most interesting part is chaining. Every function receives a result of previous function as a parameter. It's also possible to specify a dispatch queue for each function.

```swift
let deferred = Deferred<Int>();
deferred
.chain {
    ChainResult($0 + 10)
}
.chain(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
    return ChainResult($0 + 30)
}
.addCallback {
    println($0);
}
```
Will print `42` after `deferred.fulfill(2)` is called. Here, the second function will be executed in background queue while the first and the third will be executed in main queue (default value).
