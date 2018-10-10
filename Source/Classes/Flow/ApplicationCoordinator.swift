//
//  ApplicationCoordinator.swift
//  TunesSearchTask
//
//  Created by Hryhorii Maksiuk on 10/6/18.
//  Copyright © 2017 Gregory M. All rights reserved.
//

import UIKit


class ApplicationCoordinator {

    let window: UIWindow
    
    private var iTunesSearchFlowCoordinator: TunesSearchFlowCoordinator?
    private let networkService: NetworkServiceProtocol
    private let imageLoadingService: ImageLoadingServiceProtocol
    
    init(window: UIWindow) {
        self.window = window
        self.networkService = NetworkService()
        self.imageLoadingService = ImageLoadingService(networkService: networkService)
    }
    
    func start() {
        let coordinator = TunesSearchFlowCoordinator(
            window: window,
            networkService: networkService,
            imageLoadingService: imageLoadingService)
        coordinator.start()
        self.iTunesSearchFlowCoordinator = coordinator
    }
    
}
