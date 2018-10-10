//
//  TunesSearchResultCell.swift
//  TunesSearchTask
//
//  Created by Hryhorii Maksiuk on 10/6/18.
//  Copyright © 2017 Gregory M. All rights reserved.
//

import UIKit


class TunesSearchResultCell: UITableViewCell, NibLoadableView, Reusable {
    
    private struct Constants {
        
        static func noThumbnailImage() -> UIImage? {
            return UIImage(named: "NoThumbnail")
        }
        
    }
    
    // MARK: - Outlets
    
    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var imageActivityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var authorDateLabel: UILabel!
    @IBOutlet private weak var commentsLabel: UILabel!
    
    // MARK: - Private properties
    
    private var imageLoadingDataTask: URLSessionDataTask?
    private var failedToLoadImageOnce = false
    
    // MARK: - Public properties
    
    var model: TunesSearchResultServerModel? {
        didSet {
            updateContent()
        }
    }
    
    // MARK: - Lifecycle
    
    override func prepareForReuse() {
        model = nil
        
        cancelImageLoading()
        failedToLoadImageOnce = false
    }
    
    // MARK: - Public methods
    
    func startLoadingImage(imageLoadingService: ImageLoadingServiceProtocol) {
        guard let imageUrl = model?.artworkURL100, failedToLoadImageOnce == false else {
            return
        }
        
        imageActivityIndicator.startAnimating()
        
        imageLoadingDataTask = imageLoadingService.loadImage(for: imageUrl) { [weak self] result in
            guard let `self` = self else { return }
            
            switch result {
            case .success(let image):
                self.thumbnailImageView.image = image
            case .failure(_):
                self.thumbnailImageView.image = Constants.noThumbnailImage()
                self.failedToLoadImageOnce = true
            }
            
            self.imageActivityIndicator.stopAnimating()
        }
    }
    
    func cancelImageLoading() {
        guard let imageLoadingDataTask = imageLoadingDataTask else {
            return
        }
        
        imageActivityIndicator.stopAnimating()
        
        imageLoadingDataTask.cancel()
        failedToLoadImageOnce = false
    }
    
    // MARK: - Private methods
    
    private func updateContent() {
        guard let model = model else {
            thumbnailImageView.image = nil
            imageActivityIndicator.stopAnimating()
            titleLabel.text = nil
            authorDateLabel.text = nil
            commentsLabel.text = nil
            return
        }
        
        titleLabel.text = model.trackName
        authorDateLabel.text = AuthorDateFormatter().stringValue(forAuthor: model.artistName, date: model.releaseDate)
        // TODO: change the field name or smth like that, normalize cell fields naming
        commentsLabel.text = model.collectionName//CommentFormatter().commentString(fromCommentCount: model.commentsCount)
        
//        if model.artwork100URL == nil {
//            thumbnailImageView.image = Constants.noThumbnailImage()
//        }
    }
    
}
