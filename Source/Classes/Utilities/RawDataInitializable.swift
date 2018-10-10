//
//  RawDataInitializable.swift
//  TunesSearchTask
//
//  Created by Hryhorii Maksiuk on 10/6/18.
//  Copyright © 2017 Gregory M. All rights reserved.
//

import Foundation


protocol RawDataInitializable {
    
    init(rawData: [String: Any]) throws
    
}
