//
//  StringArrayViewer.swift
//  DeferredExample
//
//  Created by Mark Pervovskiy on 16/06/15.
//  Copyright (c) 2015 Mark Pervovskiy. All rights reserved.
//

import Foundation

protocol StringArrayViewer {
    subscript(num: Int) -> String { get }
    var count: Int { get }
}
