//
//  TableRefresh.swift
//  HackerBooks
//
//  Created by David Cava Jimenez on 3/2/17.
//  Copyright © 2017 David Cava Jimenez. All rights reserved.
//

import Foundation

protocol TableRefresh : class {
    func reloadDataByRefreshState(book: Book) -> Void
}
