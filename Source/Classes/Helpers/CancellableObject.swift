//
//  CancellableObject.swift
//  iTunesSearchTask
//
//  Created by Gregory Maksyuk on 10/11/18.
//  Copyright © 2018 Gregory M. All rights reserved.
//

import Foundation


protocol CancellableObject {
    func cancel()
}


extension URLSessionTask: CancellableObject {}
