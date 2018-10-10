//
//  NibLoadableView.swift
//  TunesSearchTask
//
//  Created by Hryhorii Maksiuk on 10/6/18.
//  Copyright © 2017 Gregory M. All rights reserved.
//

import UIKit


protocol NibLoadableView: class {
    static var nibName: String { get }
}


extension NibLoadableView where Self: UIView {
    static var nibName: String {
        return String(describing: self)
    }
}
