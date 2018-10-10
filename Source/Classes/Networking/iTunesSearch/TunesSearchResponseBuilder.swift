//
//  RedditListingResponseBuilder.swift
//  TunesSearchTask
//
//  Created by Hryhorii Maksiuk on 10/6/18.
//  Copyright © 2017 Gregory M. All rights reserved.
//

import Foundation


class TunesSearchResponseBuilder<ServerModel: RawDataInitializable> {
    
    private let data: Data
//    private let offset: Int
    
    init(data: Data/*, offset: Int*/) {
        self.data = data
//        self.offset = offset
    }
    
    func buildResponse() -> Result<TunesSearchResponse<ServerModel>, ParsingError> {
        do {
            let rootObject = try JSONSerialization.jsonObject(with: data, options: [])
            guard let rootDictionary = rootObject as? [String: Any] else {
                throw ParsingError.wrongType(key: "root")
            }
            
            let dataNode: [String: Any] = try rootDictionary.validatedValue(forKey: "data")
            
            return .success(.init(models: try serverModels(from: dataNode)))
//                                  pagingMarker: try pagingMarker(from: dataNode)))
        
        } catch let error as ParsingError {
            return .failure(error)
        } catch {
            return .failure(.jsonParsingError(error: error))
        }
    }
    
    // MARK: - Private methods
    
    private func serverModels(from dataNode: [String: Any]) throws -> [ServerModel] {
        let children: [[String: Any]] = try dataNode.validatedValue(forKey: "children")
        return try children.map { try ServerModel(rawData: $0) }
    }
    
//    private func pagingMarker() throws -> TunesSearchPagingMarker? {
//        return TunesSearchPagingMarker(offset: offset)
//    }
    
}
