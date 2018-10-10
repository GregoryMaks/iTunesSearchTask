//
//  RedditListingResponse.swift
//  TunesSearchTask
//
//  Created by Hryhorii Maksiuk on 10/6/18.
//  Copyright © 2017 Gregory M. All rights reserved.
//

import Foundation


struct TunesSearchResponse<ServerModel: RawDataInitializable> {
    
    static func empty<ServerModel>() -> TunesSearchResponse<ServerModel> {
        return TunesSearchResponse<ServerModel>(models: [])
    }
    
    let models: [ServerModel]
//    let pagingMarker: TunesSearchPagingMarker?
    
}
