//
//  String+QueryParameters.swift
//  TunesSearchTask
//
//  Created by Gregory Maksyuk on 10/6/18.
//  Copyright © 2018 Gregory M. All rights reserved.
//

import Foundation


extension String {
    
    func appendingParameter(value: String, for key: String) -> String {
        return self + (self.isEmpty ? "" : "&") + "\(key)+\(value)"
    }
    
    mutating func appendParameter(value: String, for key: String) {
        self += (self.isEmpty ? "" : "&") + "\(key)+\(value)"
    }
    
}
