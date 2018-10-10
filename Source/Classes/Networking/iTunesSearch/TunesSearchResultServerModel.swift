//
//  TunesSearchResultServerModel.swift
//  TunesSearchTask
//
//  Created by Hryhorii Maksiuk on 10/6/18.
//  Copyright © 2017 Gregory M. All rights reserved.
//

import Foundation


struct TunesSearchResultServerModel: RawDataInitializable {
    
    let trackName: String
    let collectionName: String?
    let artistName: String
    let kind: String
    let trackPrice: Double
    let currency: String
    let releaseDate: Date
    let artworkURL100: URL
    
    /// - Throws: ParsingError
    ///
    /// - Expects JSON in form of { key1: value, key2: value, ... }
    init(rawData: [String: Any]) throws {
        let dataNode = rawData

        trackName = try dataNode.validatedValue(forKey: "trackName")
        collectionName = try dataNode.validatedOptionalValue(forKey: "collectionName")
        artistName = try dataNode.validatedValue(forKey: "artistName")
        kind = try dataNode.validatedValue(forKey: "kind")
        trackPrice = try dataNode.validatedValue(forKey: "trackPrice")
        currency = try dataNode.validatedValue(forKey: "currency")
        releaseDate = Date()
//        releaseDate = try dataNode.validatedValue(forKey: "releaseDate", converter: Date.init(timeIntervalSince1970:))
        artworkURL100 = try dataNode.validatedValue(forKey: "artworkUrl100")
    }
    
}
