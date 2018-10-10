//
//  URL+Extensions.swift
//  TunesSearchTask
//
//  Created by Hryhorii Maksiuk on 10/6/18.
//  Copyright © 2017 Gregory M. All rights reserved.
//

import Foundation


extension URL {
    
    func urlWith(query: String) -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.query = query
        return components?.url
    }
    
    func urlWith(queryItems: [URLQueryItem]) -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.queryItems = queryItems
        return components?.url
    }
    
}
