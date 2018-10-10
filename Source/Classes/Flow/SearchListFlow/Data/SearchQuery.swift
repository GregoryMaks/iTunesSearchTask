//
//  SearchQuery.swift
//  iTunesSearchTask
//
//  Created by Gregory Maksyuk on 10/10/18.
//  Copyright © 2018 Gregory M. All rights reserved.
//

import Foundation

struct SearchQuery {
    
    var text: String
    
    var isValid: Bool {
        return text.count > 2
    }
    
}
