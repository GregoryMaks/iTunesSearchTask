//
//  TunesSearchService.swift
//  TunesSearchTask
//
//  Created by Hryhorii Maksiuk on 10/6/18.
//  Copyright © 2017 Gregory M. All rights reserved.
//

import Foundation


protocol TunesSearchServiceProtocol {
    
    func requestSearchResults(
        queryParams: [String: String],
        offset: Int,
        limit: Int,
        completion: @escaping (Result<TunesSearchResponse<TunesSearchResultServerModel>, TunesError>) -> Void
    ) -> CancellableObject
    
}


class TunesSearchService: TunesSearchServiceProtocol {

    // MARK: - Subtypes
    
    private struct Constants {
        static let apiUrl = URL(string: "https://itunes.apple.com")!
        
        static var searchAbsoluteURL: URL {
            return URL(string: "search", relativeTo: apiUrl)!
        }
    }
    
    // MARK: - Private properties
    
    private let networkService: NetworkServiceProtocol
    private let queue: DispatchQueue
    
    // MARK: - Lifecycle
    
    init(networkService: NetworkServiceProtocol, queue: DispatchQueue = .main) {
        self.networkService = networkService
        self.queue = queue
    }
    
    func requestSearchResults(
        queryParams: [String: String],
        offset: Int,
        limit: Int,
        completion: @escaping (Result<TunesSearchResponse<TunesSearchResultServerModel>, TunesError>) -> Void
    ) -> CancellableObject
    {
        var queryItems: [URLQueryItem] = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }
        queryItems.append(URLQueryItem(name: "offset", value: "\(offset)"))
        queryItems.append(URLQueryItem(name: "limit", value: "\(limit)"))
        
        let url = Constants.searchAbsoluteURL.urlWith(queryItems: queryItems)!
        
        let request = URLRequest(url: url)
        return networkService.perform(request: request) { [weak self] result in
            guard let `self` = self else { return }
            self.queue.async {
                completion(
                    result.flatMap(ifSuccess: self.verifyServerResponse, ifFailure: self.networkErrorToResult)
                          .flatMap(ifSuccess: self.parseSearchResult, ifFailure: liftError)
                )
            }
        }
    }
    
    // MARK: - Private methods
    
    private func verifyServerResponse(_ response: (data: Data?, urlResponse: HTTPURLResponse)) -> Result<Data?, TunesError>
    {
        if HttpStatus(response.urlResponse).isOk {
            return .success(response.0)
        } else {
            return .failure(.serverError(statusCode: response.urlResponse.statusCode))
        }
    }
    
    private func parseSearchResult(_ data: Data?) -> Result<TunesSearchResponse<TunesSearchResultServerModel>, TunesError>
    {
        guard let data = data else {
            return .success(.empty())
        }

        return TunesSearchResponseBuilder(data: data)
            .buildResponse()
            .flatMapError { error in .failure(.parsingError(error: error)) }
    }
    
    // MARK: - Helper methods
    
    private func networkErrorToResult(_ error: NetworkError) -> Result<Data?, TunesError> {
        return .failure(.networkError(error: error))
    }

}

