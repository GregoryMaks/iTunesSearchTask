//
//  TunesSearchViewModel.swift
//  TunesSearchTask
//
//  Created by Hryhorii Maksiuk on 10/6/18.
//  Copyright © 2017 Gregory M. All rights reserved.
//

import Foundation
import UIKit


protocol TunesSearchViewModelCoordinatorDelegate: class {
    func viewModel(_ viewModel: TunesSearchViewModel, openLinkAt url: URL)
}


class TunesSearchViewModel: NSObject {
    
    enum Error: Swift.Error, Descriptable {
        case unableToOpenUrl
        
        var stringDescription: String {
            switch self {
            case .unableToOpenUrl:
                return "Unable to open post link"
            }
        }
    }
    
    let imageLoadingService: ImageLoadingServiceProtocol
    let dataSource: TunesSearchDataSource
    
    weak var coordinatorDelegate: TunesSearchViewModelCoordinatorDelegate?
    
    // MARK: - Lifecycle
    
    init(networkService: NetworkServiceProtocol, imageLoadingService: ImageLoadingServiceProtocol) {
        dataSource = TunesSearchDataSource(networkService: networkService)
        self.imageLoadingService = imageLoadingService
    }
    
    // MARK: - Public
    
    func openLink(for itemModel: TunesSearchResultServerModel) -> Result<Void, TunesSearchViewModel.Error> {
//        if let contentUrl = itemModel.url {
//            coordinatorDelegate?.viewModel(self, openLinkAt: contentUrl)
//            return .success()
//        } else {
//            return .failure(.noImageAttached)
//        }
        
        return .failure(.unableToOpenUrl)
    }
    
}

extension TunesSearchViewModel: UISearchResultsUpdating {
    
    public func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        
        print("Search term: \(searchText)")
        // TODO
    }
    
}
