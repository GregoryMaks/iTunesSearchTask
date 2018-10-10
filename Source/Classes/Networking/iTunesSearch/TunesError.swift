//
//  TunesError.swift
//  TunesSearchTask
//
//  Created by Gregory Maksyuk on 10/6/18.
//  Copyright © 2018 Gregory M. All rights reserved.
//

import Foundation


enum TunesError: Error, Descriptable {
    case networkError(error: NetworkError)
    case serverError(statusCode: Int)
    case parsingError(error: ParsingError)
    
    var stringDescription: String {
        switch self {
        case .networkError(let networkError):
            return "Network error: \(networkError.stringDescription)"
        case .serverError(let statusCode):
            return "Server error \(statusCode)"
        case .parsingError(let parsingError):
            return "Parsing error: \(parsingError.stringDescription)"
        }
    }
    
    var isSilent: Bool {
        if case .networkError(let networkError) = self, case .cancelled = networkError {
            return true
        }
        
        return false
    }
}
