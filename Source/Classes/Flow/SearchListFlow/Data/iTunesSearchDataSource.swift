//
//  TunesSearchDataSource.swift
//  TunesSearchTask
//
//  Created by Hryhorii Maksiuk on 10/6/18.
//  Copyright © 2017 Gregory M. All rights reserved.
//

import Foundation


protocol TunesSearchDataSourceDelegate: class {
    
    func dataSourceDidFinishLoadingData(_ dataSource: TunesSearchDataSource)
    func dataSource(_ dataSource: TunesSearchDataSource, didFinishWithError error: TunesError)
    
}


class TunesSearchDataSource {
    
    private struct Constants {
        static let defaultLimit = 10
    }
    
    private enum LoadingType {
        case fullReload
        case loadMore
    }
    
    // MARK: - Private properties
    
    private let iTunesSearchService: TunesSearchService
    private var isLoading = false
    private var loadedItemCount = 0
    private var latestSearchQuery: SearchQuery?
    private var cancellableRequestObject: CancellableObject?
    
    // MARK: - Public properties
    
    weak var delegate: TunesSearchDataSourceDelegate?
    
    private (set) var models = [TunesSearchResultServerModel]()
    
    // MARK: - Lifecycle
    
    init(networkService: NetworkServiceProtocol) {
        iTunesSearchService = TunesSearchService(networkService: networkService)
    }
    
    // MARK: - Public methods
    
    func loadData(withSearchText text: String) {
        let query = SearchQuery(text: text)
        latestSearchQuery = query
        loadDataChunk(loadingType: .fullReload, withSearchQuery: query)
    }
    
    func loadMoreData() {
        guard let query = latestSearchQuery else { return }
        loadDataChunk(loadingType: .loadMore, withSearchQuery: query)
    }
    
    func shouldReloadData(for searchText: String) -> Bool {
        return latestSearchQuery?.text != searchText
    }
    
    func cancelLoadingData() {
        cancellableRequestObject?.cancel()
        cancellableRequestObject = nil
        latestSearchQuery = nil
        isLoading = false
        loadedItemCount = 0
    }
    
    // MARK: - Private methods
    
    private func loadDataChunk(loadingType: LoadingType, withSearchQuery query: SearchQuery) {
        guard !isLoading else { return }
        guard query.isValid else { return }
        
        let requestOffset = loadedItemCount
        
        isLoading = true
        cancellableRequestObject = iTunesSearchService.requestSearchResults(
            queryParams: ["media": "movie", "term": query.text, "country": "US"],
            offset: requestOffset,
            limit: Constants.defaultLimit)
        { [weak self] result in
            guard let `self` = self else { return }
            
            switch result {
            case .success(let response):
                self.updateModels(withModels: response.models, shouldAppend: (loadingType == .loadMore))
                self.loadedItemCount = requestOffset + Constants.defaultLimit
                
                self.isLoading = false
                self.delegate?.dataSourceDidFinishLoadingData(self)
                
            case .failure(let error):
                self.isLoading = false
                self.delegate?.dataSource(self, didFinishWithError: error)
            }
            
            self.cancellableRequestObject = nil
        }
    }
    
    private func updateModels(withModels newModels: [TunesSearchResultServerModel], shouldAppend: Bool) {
        models = shouldAppend ? (models + newModels) : newModels
    }
    
}
