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
    
    init(data: Data) {
        self.data = data
    }
    
    func buildResponse() -> Result<TunesSearchResponse<ServerModel>, ParsingError> {
        do {
            let rootObject = try JSONSerialization.jsonObject(with: data, options: [])
            guard let rootDictionary = rootObject as? [String: Any] else {
                throw ParsingError.wrongType(key: "root")
            }
              
            let dataNodesArray: [[String: Any]] = try rootDictionary.validatedValue(forKey: "results")
            
            return .success(.init(models: try serverModels(from: dataNodesArray)))
        } catch let error as ParsingError {
            return .failure(error)
        } catch {
            return .failure(.jsonParsingError(error: error))
        }
    }
    
    // MARK: - Private methods
    
    private func serverModels(from dataNodes: [[String: Any]]) throws -> [ServerModel] {
        return try dataNodes.map { try ServerModel(rawData: $0) }
    }
    
}
