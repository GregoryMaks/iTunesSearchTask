//
//  TunesSearchViewController.swift
//  TunesSearchTask
//
//  Created by Hryhorii Maksiuk on 10/6/18.
//  Copyright © 2017 Gregory M. All rights reserved.
//

import UIKit


class TunesSearchViewController: UITableViewController {
    
    private struct Constants {
        // These are not magic numbers, used by TV to approximate scrolling
        static let estimatedRowHeight: CGFloat = 87.0
        static let estimatedSectionFooterHeight: CGFloat = 45.0
    }

    
    // MARK: - Private properties
    
    fileprivate var viewModel: TunesSearchViewModel!
    fileprivate var searchController: UISearchController?
    fileprivate var fullScreenLoadingController: UIAlertController?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(cell: TunesSearchResultCell.self)
        tableView.register(headerFooterView: LoadMoreFooterView.self)
        
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = Constants.estimatedRowHeight
        
        tableView.sectionFooterHeight = UITableViewAutomaticDimension;
        tableView.estimatedSectionFooterHeight = Constants.estimatedSectionFooterHeight
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        
        let tempSearchController = UISearchController(searchResultsController: nil)
        tempSearchController.searchResultsUpdater = viewModel
        tempSearchController.searchBar.placeholder = "Artist or song name"
        tempSearchController.hidesNavigationBarDuringPresentation = false
        tempSearchController.obscuresBackgroundDuringPresentation = false
        
        tableView.tableHeaderView = tempSearchController.searchBar;
        
        self.searchController = tempSearchController
        
        definesPresentationContext = true;
        
        viewModel.dataSource.loadData()
    }
    
    // MARK: - Public methods
    
    func bind(viewModel: TunesSearchViewModel) {
        self.viewModel = viewModel
        viewModel.dataSource.delegate = self
    }
    
    // MARK: - Actions
    
    @objc private func pullToRefresh(_ sender: UIRefreshControl) {
        viewModel.dataSource.loadData()
    }
    
    // MARK: - Private methods

    // MARK: - Loading indicators
    
    private func showFullScreenLoadingController(completion: (() -> Void)? = nil) {
        if let fullScreenLoadingController = fullScreenLoadingController {
            fullScreenLoadingController.dismiss(animated: false, completion: nil)
        }
        
        let indicator = UIAlertController(title: nil,
                                          message: "Processing...",
                                          preferredStyle: .alert)
        present(indicator, animated: true, completion: completion)
        
        fullScreenLoadingController = indicator
    }
    
    private func hideFullScreenLoadingController(animated: Bool = true, completion: (() -> Void)? = nil) {
        guard let fullScreenLoadingController = fullScreenLoadingController else {
            completion?()
            return
        }
        
        fullScreenLoadingController.dismiss(animated: animated, completion: completion)
    }
    
    private func showFullscreenMessage(_ message: String, duration: TimeInterval, completion: (() -> Void)? = nil) {
        let controller = UIAlertController(title: nil,
                                          message: message,
                                          preferredStyle: .alert)
        present(controller, animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
            controller.dismiss(animated: true, completion: completion)
        }
    }
    
    // MARK: - Error handlers
    
    fileprivate func handleViewModelError(_ error: TunesSearchViewModel.Error) {
        showErrorAlert(message: error.stringDescription)
    }
    
    fileprivate func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error",
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}


// MARK: - UITableViewDataSource

extension TunesSearchViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TunesSearchResultCell = tableView.dequeueReusableCell(for: indexPath)
        cell.model = viewModel.dataSource.models[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSource.models.count
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        // Hide header
        return CGFloat.leastNormalMagnitude
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return tableView.dequeueReusableHeaderFooterView() as LoadMoreFooterView
    }
    
}


// MARK: - UITableViewDelegate

extension TunesSearchViewController {

    override func tableView(_ tableView: UITableView,
                            willDisplay cell: UITableViewCell,
                            forRowAt indexPath: IndexPath)
    {
        (cell as? TunesSearchResultCell).flatMap {
            $0.startLoadingImage(imageLoadingService: self.viewModel.imageLoadingService)
        }
    }
    
    override func tableView(_ tableView: UITableView,
                            didEndDisplaying cell: UITableViewCell,
                            forRowAt indexPath: IndexPath)
    {
        (cell as? TunesSearchResultCell).flatMap {
            $0.cancelImageLoading()
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        viewModel.dataSource.loadMoreData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let itemModel = viewModel.dataSource.models[indexPath.row]
        viewModel
            .openLink(for: itemModel)
            .mapError(handleViewModelError)
    }
}


// MARK: - TunesSearchDataSourceDelegate

extension TunesSearchViewController: TunesSearchDataSourceDelegate {
    
    func dataSourceDidFinishLoadingData(_ dataSource: TunesSearchDataSource) {
        tableView.reloadData()
        refreshControl?.endRefreshing()
    }
    
    func dataSource(_ dataSource: TunesSearchDataSource, didFinishWithError error: TunesError) {
        refreshControl?.endRefreshing()
        refreshControl?.isHidden = true
        showErrorAlert(message: error.stringDescription)
    }
    
}
