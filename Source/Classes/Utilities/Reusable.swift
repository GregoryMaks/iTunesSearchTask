//
//  Reusable.swift
//  TunesSearchTask
//
//  Created by Hryhorii Maksiuk on 10/6/18.
//  Copyright © 2017 Gregory M. All rights reserved.
//

import UIKit


protocol Reusable: class {
    static var defaultReuseIdentifier: String { get }
}


extension Reusable {
    static var defaultReuseIdentifier: String {
        return String(describing: self)
    }
}


// MARK: - UITableView

extension UITableView {
    
    func register<T: UITableViewCell>(cell: T.Type) where T: Reusable, T: NibLoadableView {
        let nib = UINib(nibName: T.nibName, bundle: Bundle.main)
        register(nib, forCellReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    func dequeueReusableCell<T: Reusable>(for indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withIdentifier: T.defaultReuseIdentifier, for: indexPath) as! T
    }
    
    func register<T: UITableViewHeaderFooterView>(headerFooterView: T.Type) where T: Reusable, T: NibLoadableView {
        let nib = UINib(nibName: T.nibName, bundle: Bundle.main)
        register(nib, forHeaderFooterViewReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    func dequeueReusableHeaderFooterView<T: Reusable>() -> T {
        return self.dequeueReusableHeaderFooterView(withIdentifier: T.defaultReuseIdentifier) as! T
    }
    
}
